/**
 * A fire-and-forget mechanism to run functions that update things.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module fewdee.updater;

import allegro5.allegro;
import std.conv;
import fewdee.event;
import fewdee.event_manager;
import fewdee.low_level_event_handler;


/**
 * A function callable by an $(D Updater). It must return $(D true) if it wants
 * to be called again or $(D false) if doesn't want to. And it receives as
 * parameter the amount of time by which the function must update whatever it is
 * updating (this amount of time is usually interpreted as being in seconds, but
 * this actually depends on which concrete $(D Updater) is being used, and maybe
 * even how it is being used).
 *
 * Notice that this "function" is actually a delegate, so that it can have its
 * own state (closures for the win!).
 */
public alias bool delegate(double deltaTime) UpdaterFunc;


/**
 * An opaque identifier identifying an $(D UpdaterFunc) added to an $(D
 * Updater). It can be used to remove the updater function.
 */
public alias size_t UpdaterFuncID;


/**
 * An "updater function ID" that is guaranteed to never be equal to any real
 * updater function ID. It is safe to pass $(D InvalidUpdaterFuncID) to $(D
 * Updater.remove()).
 */
public immutable UpdaterFuncID InvalidUpdaterFuncID = 0;


/**
 * Base class for updaters.
 *
 * This implements a fire-and-forget mechanism to run functions that update
 * things. Originally thought as a simple way to run shortish animations, but
 * can in fact be used to do anything.
 *
 * This class can be used as is, but it will require periodic calls to the $(D
 * update()) method to work. You may want to use some subclass of it ($(D
 * TickBasedUpdater) is a good candidate), or perhaps subclass it yourself, and
 * set things up in your subclass so that $(D update()) gets called
 * periodically.
 */
public class Updater
{
   /**
    * Runs all updater functions, and removes those which no longer want to be
    * called.
    *
    * If you are using an $(D Updater) directly, this must be called
    * periodically so that the updater functions get actually called. If
    * subclassing, you may want to make your subclass call this in response to
    * some event, or something like this, in an automated fashion.
    */
   public final void update(double deltaTime)
   {
      UpdaterFuncID[] toRemove;

      foreach(id, func; _updaterFuncs)
      {
         if (!func(deltaTime))
            toRemove ~= id;
      }

      foreach(id; toRemove)
         _updaterFuncs.remove(id);
   }

   /// Adds an updater function to the Updater.
   public final UpdaterFuncID add(UpdaterFunc func)
   {
      _updaterFuncs[_nextUpdaterFuncID] = func;
      return _nextUpdaterFuncID++;
   }

   /**
    * Removes a given updater function from the $(D Updater).
    *
    * Notice that updater functions are automatically removed when they return
    * $(D false). This method can be used to remove a function before it
    * considers itself complete, or an updater that always returns $(D true).
    *
    * Parameters:
    *    id = The ID of the updater function to be removed. $(D
    *       InvalidUpdaterFuncID) can be safely passed here (this function will
    *       do nothing, in this case).
    *
    * Returns: $(D true) if the updater function was removed; $(D false)
    *    otherwise (which means that an updater function with the given ID does
    *    not exist).
    */
   public final bool remove(UpdaterFuncID id)
   {
      return _updaterFuncs.remove(id);
   }

   /// The active updater functions.
   private UpdaterFunc[UpdaterFuncID] _updaterFuncs;

   /**
    * The next updater function ID to use. Notice that the ID is unique only
    * within a certain $(D Updater).
    */
   private size_t _nextUpdaterFuncID = InvalidUpdaterFuncID + 1;
}



/**
 * An $(D Updater) subclass that will automatically call the updater functions
 * as "tick" events ($(D FEWDEE_EVENT_TICK)) are generated by the $(D
 * EventManager).
 *
 * Use this when your updater functions update the game state.
 *
 * See_also: $(D DrawBasedUpdater)
 */
public class TickBasedUpdater: Updater, LowLevelEventHandlerInterface
{
   // Automatically registers and de-registers with the Event Manager.
   mixin LowLevelEventHandlerAutoRegister;

   /**
    * When getting a tick event, calls all updater functions and remove the ones
    * that don't want to be called anymore.
    */
   public override void handleEvent(in ref ALLEGRO_EVENT event)
   {
      if (event.type != FEWDEE_EVENT_TICK)
         return;

      update(event.user.deltaTime);
   }

   /**
    * This is called when starting to process the events of a tick.
    *
    * TODO: This should be $(D package) instead of $(D public), but D (as of DMD
    *    2.063) doesn't seem to like $(D package) virtual functions.
    */
   public override void beginTick() { }

   /**
    * This is called when finished to process the events of a tick.
    *
    * TODO: This should be $(D package) instead of $(D public), but D (as of DMD
    *    2.063) doesn't seem to like $(D package) virtual functions.
    */
   public override void endTick() { }
}


/**
 * An $(D Updater) subclass that will automatically call the updater functions
 * as "draw" events ($(D FEWDEE_EVENT_DRAW)) are generated by the $(D
 * EventManager).
 *
 * Use this when your updater functions update the game display only, without
 * touching the "real" game state. For example, if you add an updater function
 * just to make your UI more lively, you probably want to use a $(D
 * DrawBasedUpdater).
 */
public class DrawBasedUpdater: Updater, LowLevelEventHandlerInterface
{
   // Automatically registers and de-registers with the Event Manager.
   mixin LowLevelEventHandlerAutoRegister;

   /**
    * When getting a tick event, calls all updater functions and remove the ones
    * that don't want to be called anymore.
    */
   public override void handleEvent(in ref ALLEGRO_EVENT event)
   {
      if (event.type != FEWDEE_EVENT_DRAW)
         return;

      update(event.user.deltaTime);
   }

   /**
    * This is called when starting to process the events of a tick.
    *
    * TODO: This should be $(D package) instead of $(D public), but D (as of DMD
    *    2.063) doesn't seem to like $(D package) virtual functions.
    */
   public override void beginTick() { }

   /**
    * This is called when finished to process the events of a tick.
    *
    * TODO: This should be $(D package) instead of $(D public), but D (as of DMD
    *    2.063) doesn't seem to like $(D package) virtual functions.
    */
   public override void endTick() { }
}

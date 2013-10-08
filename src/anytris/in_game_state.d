/**
 * The "in game" state -- where the fun happens!
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.in_game_state;

import fewdee.all;
import anytris.game;
import anytris.drawing;
import anytris.input;


/// The "in game" state -- where the fun happens!
public class InGameState: GameState
{
   /**
    * Constructs the state.
    *
    * Parameters:
    *    numBlocksPerPiece = Number of blocks to use when creating pieces.
    */
   public this(int numBlocksPerPiece)
   {
      _game = new Game(numBlocksPerPiece);

      // Put resources in easy to access variables
      _musicBG = ResourceManager.streams["inGame"];

      // Handle game events
      _inputHandlerIDs ~= InputManager.addCommandHandler(
         Commands.MOVE_LEFT,
         delegate(in ref InputHandlerParam param)
         {
            _game.movePieceLeft();
         });

      _inputHandlerIDs ~= InputManager.addCommandHandler(
         Commands.MOVE_RIGHT,
         delegate(in ref InputHandlerParam param)
         {
            _game.movePieceRight();
         });

      _inputHandlerIDs ~= InputManager.addCommandHandler(
         Commands.ROTATE_CW,
         delegate(in ref InputHandlerParam param)
         {
            _game.rotatePieceCW();
         });

      _inputHandlerIDs ~= InputManager.addCommandHandler(
         Commands.ROTATE_CCW,
         delegate(in ref InputHandlerParam param)
         {
            _game.rotatePieceCCW();
         });

      _inputHandlerIDs ~= InputManager.addCommandHandler(
         Commands.SOFT_DROP,
         delegate(in ref InputHandlerParam param)
         {
            _game.softDrop();
         });

      _inputHandlerIDs ~= InputManager.addCommandHandler(
         Commands.HARD_DROP,
         delegate(in ref InputHandlerParam param)
         {
            _game.hardDrop();
         });

      // Quit if "ESC" is pressed.
      addHandler(
         ALLEGRO_EVENT_KEY_DOWN,
         delegate(in ref ALLEGRO_EVENT event)
         {
            if (event.keyboard.keycode == ALLEGRO_KEY_ESCAPE)
               popState();
         });

      // Tick
      addHandler(
         FEWDEE_EVENT_TICK,
         delegate(in ref ALLEGRO_EVENT event)
         {
            if (!_game.tick(event.user.deltaTime))
            {
               import std.stdio;
               writefln("Game over!");
               popState();
            }
         });

      // Draw
      addHandler(
         FEWDEE_EVENT_DRAW,
         delegate(in ref ALLEGRO_EVENT event)
         {
            al_clear_to_color(al_map_rgb(0, 0, 0));
            _game.draw();
         });

      // Start the background music
      _musicBG.playMode = ALLEGRO_PLAYMODE.ALLEGRO_PLAYMODE_LOOP;
      _musicBG.play();
   }

   /// Destroys the state.
   public ~this()
   {
      foreach (handlerID; _inputHandlerIDs)
         InputManager.removeCommandHandler(handlerID);

      _musicBG.stop();
   }

   /**
    * The IDs of the input handlers used by this state.
    *
    * We have to store them in order to remove them when the state is
    * destroyed. If we don't remove them, the handlers will remain active even
    * after the state is destroyed (with nasty results, it goes without saying).
    */
   private CommandHandlerID[] _inputHandlerIDs;

   /// The game.
   private Game _game;

   /// The background music.
   private AudioStream _musicBG;
}

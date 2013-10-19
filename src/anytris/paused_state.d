/**
 * The "paused" state.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.paused_state;

// import std.string;
import fewdee.all;
// import anytris.game;
// import anytris.in_game_state;
import anytris.drawing;
// import anytris.input;


/// The "paused" state.
public class PausedState: GameState
{
   /// Constructs the state.
   public this()
   {
      // Draw
      const x = DisplayManager.getDisplay("main").width / 2.0;
      addHandler(
         FEWDEE_EVENT_DRAW,
         delegate(in ref ALLEGRO_EVENT event)
         {
            // Draw the "paused" bitmap, which merely covers the parts of the
            // screen that shouldn't be displayed while paused (like the
            // playfield itself)
            al_draw_bitmap(ResourceManager.bitmaps["paused"], 0.0, 0.0, 0);

            // And then draw the "Paused" texts
            drawText("gameOverScore", "Paused", x, 150,
                     ALLEGRO_ALIGN_CENTRE);
            drawText("gameOverPressEsc", "Press Q to quit", x, 250,
                     ALLEGRO_ALIGN_CENTRE);
            drawText("gameOverPressEsc", "Press any other key to return to game",
                     x, 315, ALLEGRO_ALIGN_CENTRE);
         });

      // Handle key down events
      addHandler(ALLEGRO_EVENT_KEY_DOWN,
                 delegate(in ref ALLEGRO_EVENT event)
                 {
                    if (event.keyboard.keycode == ALLEGRO_KEY_Q)
                       popState(2);
                    else
                       popState();

                    return;
                 });
   }
}

/**
 * The "game over" state, which also displays the score.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.game_over_state;

import std.conv;
import std.string;
import fewdee.all;
import anytris.drawing;


/// The "game over" state.
public class GameOverState: GameState
{
   /**
    * Constructs the state.
    *
    * Parameters:
    *    score = The score, which is displayed along the "game over" message.
    */
   public this(int score)
   {
      _score = score;

      const x = DisplayManager.getDisplay("main").width / 2.0;

      // Draw
      addHandler(
         FEWDEE_EVENT_DRAW,
         delegate(in ref ALLEGRO_EVENT event)
         {
            al_clear_to_color(al_map_rgb_f(0.0, 0.0, 0.0));

            drawText("gameOver", "Game Over", x, 200, ALLEGRO_ALIGN_CENTRE);
            drawText("gameOverScore",
                     "You scored " ~ to!string(_score) ~ " points",
                     x, 300, ALLEGRO_ALIGN_CENTRE);
            drawText("gameOverPressEsc", "Press Esc to continue",
                     x, 350, ALLEGRO_ALIGN_CENTRE);
         });

      // Handle key down events
      addHandler(
         ALLEGRO_EVENT_KEY_DOWN,
         delegate(in ref ALLEGRO_EVENT event)
         {
            if (event.keyboard.keycode == ALLEGRO_KEY_ESCAPE)
            {
               popState();
               return;
            }
         });
   }

   /// The score.
   private const int _score;
}

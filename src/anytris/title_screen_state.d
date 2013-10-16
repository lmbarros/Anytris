/**
 * The "title screen" state, in which the game starts.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.title_screen_state;

import std.string;
import fewdee.all;
import anytris.game;
import anytris.in_game_state;
import anytris.drawing;
import anytris.input;


/// The "title screen" state, in which the game starts.
public class TitleScreenState: GameState
{
   /// Constructs the state.
   public this()
   {
      // Put resources in easy to access variables
      _musicBG = ResourceManager.streams["intro"];

      // Draw
      addHandler(
         FEWDEE_EVENT_DRAW,
         delegate(in ref ALLEGRO_EVENT event)
         {
            al_clear_to_color(al_map_rgb_f(0.5, 0.15, 0.15));
            drawText("title", "Anytris", 25, 10);
            drawText("subtitle", "Tetris was Tetris for a reason", 350, 187);

            drawText("menu", "Press 1 to 0 (but not 4) to play", 50, 400);
            drawText("menu", "Press Esc to quit", 50, 450);
         });

      // Handle key down events
      addHandler(ALLEGRO_EVENT_KEY_DOWN,
                 delegate(in ref ALLEGRO_EVENT event)
                 {
                    if (event.keyboard.keycode == ALLEGRO_KEY_ESCAPE)
                    {
                       popState();
                       return;
                    }

                    int numBlocksPerPiece = 0;

                    switch (event.keyboard.keycode)
                    {
                       // Four is not allowed! This is not Tetris!
                       case ALLEGRO_KEY_1: numBlocksPerPiece = 1; break;
                       case ALLEGRO_KEY_2: numBlocksPerPiece = 2; break;
                       case ALLEGRO_KEY_3: numBlocksPerPiece = 3; break;
                       case ALLEGRO_KEY_5: numBlocksPerPiece = 5; break;
                       case ALLEGRO_KEY_6: numBlocksPerPiece = 6; break;
                       case ALLEGRO_KEY_7: numBlocksPerPiece = 7; break;
                       case ALLEGRO_KEY_8: numBlocksPerPiece = 8; break;
                       case ALLEGRO_KEY_9: numBlocksPerPiece = 9; break;
                       case ALLEGRO_KEY_0: numBlocksPerPiece = 10; break;
                       default: break; // do nothing
                    }

                    if (numBlocksPerPiece > 0)
                       pushState(new InGameState(numBlocksPerPiece));
                 });

      // Start the background music
      _musicBG.playMode = ALLEGRO_PLAYMODE.ALLEGRO_PLAYMODE_LOOP;
      _musicBG.play();
   }

   /// Destroys the state.
   public ~this()
   {
      _musicBG.stop();
   }

   // Inherit docs.
   public override void onBury()
   {
      super.onBury();
      _musicBG.stop();
   }

   // Inherit docs.
   public override void onDigOut()
   {
      super.onDigOut();
      _musicBG.play();
   }

   /// The background music.
   private AudioStream _musicBG;
}

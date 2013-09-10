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
   /// Constructs the state.
   public this()
   {
      _game = new Game();

      // Put resources in easy to access variables
      _musicBG = ResourceManager.streams["inGame"];

      // Handle game events
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      // xxxxxxxxx store ids, remove upon destruction
      InputManager.addCommandHandler(
         Commands.MOVE_LEFT,
         delegate(in ref InputHandlerParam param)
         {
            _game.movePieceLeft();
         });

      InputManager.addCommandHandler(
         Commands.MOVE_RIGHT,
         delegate(in ref InputHandlerParam param)
         {
            _game.movePieceRight();
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
            _game.tick(event.user.deltaTime);
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
      _musicBG.play();
   }

   /// Destroys the state.
   public ~this()
   {
      _musicBG.stop();
   }

   /// The game.
   private Game _game;

   /// The background music.
   private AudioStream _musicBG;
}

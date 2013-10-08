/**
 * Anytris input.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.input;

import fewdee.all;

/**
 * The time, in seconds, between two consecutive left/right piece movements
 * while the corresponding key is kept pressed.
 */
enum leftRightRepeatingInterval = 0.15;

/**
 * The time, in seconds, between two consecutive soft drop steps (while
 * maintaining the key pressed).
 */
enum downRepeatingInterval = 0.1;


/// The high-level commands used by Anytris.
public enum Commands
{
   MOVE_LEFT,  /// Moves the piece one block to the right.
   MOVE_RIGHT, /// Moves the piece one block to the left.
   ROTATE_CCW, /// Rotates the piece in the counter-clockwise direction.
   ROTATE_CW,  /// Rotates the piece in the clockwise direction.
   SOFT_DROP,  /// Moves the piece one block down.
   HARD_DROP,  /// Moves the piece down as much as possible.
}


// Sets the input subsystem up.
public void setupInput()
{
   initInputCommandsConstants!Commands();

   with (Commands)
   {
      InputManager.addCommandTrigger(
         MOVE_LEFT, new RepeatingTrigger(
            new KeyDownTrigger(ALLEGRO_KEY_LEFT),
            new KeyUpTrigger(ALLEGRO_KEY_LEFT),
            leftRightRepeatingInterval));

      InputManager.addCommandTrigger(
         MOVE_RIGHT, new RepeatingTrigger(
            new KeyDownTrigger(ALLEGRO_KEY_RIGHT),
            new KeyUpTrigger(ALLEGRO_KEY_RIGHT),
            leftRightRepeatingInterval));

      InputManager.addCommandTrigger(
         ROTATE_CW, new KeyDownTrigger(ALLEGRO_KEY_X));

      InputManager.addCommandTrigger(
         ROTATE_CCW, new KeyDownTrigger(ALLEGRO_KEY_Z));

      InputManager.addCommandTrigger(
         SOFT_DROP, new RepeatingTrigger(
            new KeyDownTrigger(ALLEGRO_KEY_DOWN),
            new KeyUpTrigger(ALLEGRO_KEY_DOWN),
            downRepeatingInterval));

      InputManager.addCommandTrigger(
         HARD_DROP, new KeyDownTrigger(ALLEGRO_KEY_SPACE));
   }
}

/**
 * The game logic, rules and execution.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.game;

import fewdee.all;
import anytris.cell_state;
import anytris.constants;
import anytris.input;
import anytris.piece;


/// Time, in seconds, to drop the piece by one row.
private enum dropTime = 0.5;


/// The game logic, rules and execution.
public class Game
{
   /// Constructs the $(D Game).
   public this()
   {
      _piece = makePiece(0);
      _piece.x = 0;
      _piece.y = PLAYFIELD_VISIBLE_HEIGHT;

      with (Commands)
      {
         InputManager.addCommandHandler(MOVE_LEFT, &movePieceLeft);
         InputManager.addCommandHandler(MOVE_RIGHT, &movePieceRight);
      }
   }

   /**
    * Updates the game state by $(D deltaTime) seconds.
    *
    * Returns:
    *    $(D true) if we shall keep playing the game; $(D false) if not (AKA
    *    "game over").
    */
   public final bool tick(double deltaTime)
   {
      _timeToDrop -= deltaTime;

      if (_timeToDrop <= 0)
         dropPiece();

      return !isGameOver;
   }

   /// Handles $(D MOVE_LEFT) commands.
   private final void movePieceLeft(in ref InputHandlerParam param)
   {
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      // xxxxxxxxx check for collisions with blocks
      if (_piece.x + _piece.minX > 0)
         _piece.x = _piece.x - 1;
   }

   /// Handles $(D MOVE_RIGHT) commands.
   private final void movePieceRight(in ref InputHandlerParam param)
   {
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      // xxxxxxxxx check for collisions with blocks
      if (_piece.x + piece.maxX + 1 < PLAYFIELD_WIDTH)
         _piece.x = _piece.x + 1;
   }

   /// Did the player lose?
   private @property bool isGameOver()
   {
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      return false;
   }

   /**
    * Drops a piece by one row.
    *
    * This does also does all the checks for game over, for filled rows
    * (including removing the filled rows), etc.
    */
   private final void dropPiece()
   {
      if (canDropPiece)
         _piece.y = _piece.y - 1;
      _timeToDrop += dropTime;
   }

   /// Can the piece drop by one row without colliding with existing blocks?
   private final @property bool canDropPiece()
   {
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      return _piece.y + piece.minY > 0;
   }

   /*
    * The playfield -- the "well" where the pieces fall.
    *
    * The playfield has a certain height ($(D PLAYFIELD_HEIGHT)), but the top
    * portion ($(D PLAYFIELD_VANISH_ZONE) rows) is hidden.
    *
    * Playfield horizontal coordinates start at 0 (the left side) and grow
    * towards the right side. Vertical coordinates start at 0 (the bottom side)
    * and grow towards the top.
    *
    * Note that indexing is made as $(D playfield[row][column]), which is like
    * "$(I y), $(I x)" instead of "$(I x), $(I y)". The reason for this is
    * easing the assignment of whole rows, as is done when cleaning filled rows.
    *
    * TODO: Are the blocks for the falling piece included here?
    */
   public @property const(CellState[PLAYFIELD_WIDTH][PLAYFIELD_HEIGHT])
   playfield() inout
   {
      return _playfield;
   }

   /// Ditto
   private CellState[PLAYFIELD_WIDTH][PLAYFIELD_HEIGHT] _playfield;

   /// The falling piece.
   public @property const(Piece) piece() inout
   {
      return _piece;
   }

   /// Ditto
   private Piece _piece;

   /// Time remaining until the next time the piece drops one row.
   private double _timeToDrop = dropTime;
}

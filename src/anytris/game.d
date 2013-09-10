/**
 * The game logic, rules and execution.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.game;

import anytris.cell_state;
import anytris.constants;
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
      _piece.y = PLAYFIELD_HEIGHT - _piece.size;
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
      _piece.y = _piece.y - 1;
      _timeToDrop += dropTime;
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

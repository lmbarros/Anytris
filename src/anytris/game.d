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


/// The game logic, rules and execution.
public class Game
{
   /// Constructs the $(D Game).
   public this()
   {
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      _piece = makePiece(0);

      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      foreach(i; 0..PLAYFIELD_WIDTH)
      {
         foreach(j; 0..PLAYFIELD_HEIGHT)
         {
            switch (j)
            {
               import anytris.cell_state;

               case 0: .. case 3:
                  _playfield[j][i] = CellState.RED;
                  break;

               case 4: .. case 7:
                  _playfield[j][i] = CellState.GREEN;
                  break;

               case 8: .. case 11:
                  _playfield[j][i] = CellState.BLUE;
                  break;

               case 12: .. case 15:
                  _playfield[j][i] = CellState.YELLOW;
                  break;

               case 16: .. case 19:
                  _playfield[j][i] = CellState.PINK;
                  break;

               case 20: .. case 23:
                  _playfield[j][i] = CellState.CYAN;
                  break;

               default:
                  _playfield[j][i] = CellState.EMPTY;
                  break;
            }
         }
      }
   }

   /// Updates the game state by $(D deltaTime) seconds.
   public final void tick(double deltaTime)
   {
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   }

   /// Did the player lose?
   public @property bool isGameOver()
   {
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      return false;
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
}

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
                  _playfield[i][j] = CellState.RED;
                  break;

               case 4: .. case 7:
                  _playfield[i][j] = CellState.GREEN;
                  break;

               case 8: .. case 11:
                  _playfield[i][j] = CellState.BLUE;
                  break;

               case 12: .. case 15:
                  _playfield[i][j] = CellState.YELLOW;
                  break;

               case 16: .. case 19:
                  _playfield[i][j] = CellState.PINK;
                  break;

               case 20: .. case 23:
                  _playfield[i][j] = CellState.CYAN;
                  break;

               default:
                  _playfield[i][j] = CellState.EMPTY;
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
    * Empty cells are $(D null).
    *
    * TODO: Are the blocks for the falling piece included here?
    */
   public @property const(CellState[PLAYFIELD_HEIGHT][PLAYFIELD_WIDTH])
   playfield() inout
   {
      return _playfield;
   }

   /// Ditto
   private CellState[PLAYFIELD_HEIGHT][PLAYFIELD_WIDTH] _playfield;

   /// The falling piece.
   public @property const(Piece) piece() inout
   {
      return _piece;
   }

   /// Ditto
   private Piece _piece;
}

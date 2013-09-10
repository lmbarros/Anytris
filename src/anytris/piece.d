/**
 * Pieces -- polyominos.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.piece;

import anytris.cell_state;


/**
 * A piece; a polyomino.
 *
 * See_also: https://en.wikipedia.org/wiki/Polyomino.
 */
public class Piece
{
   /// Returns a copy of this piece, rotated in the clockwise direction.
   public final @property Piece clockwise()
   {
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      return this;
   }

   /// Returns a copy of this piece, rotated in the counter-clockwise direction.
   public final @property Piece counterClockwise()
   {
      // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      return this;
   }

   /// The square grid defining the piece; $(D true) marks filled blocks.
   public final @property const(bool[][]) grid() inout
   {
      return _grid;
   }

   /// Ditto
   private bool[][] _grid;

   /// The piece color.
   public final @property CellState color() inout
   {
      return _color;
   }

   /// Ditto
   CellState _color;
}


/// Creates and returns a random piece of $(D numBlocks) blocks.
public Piece makePiece(uint numBlocks)
{
   // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   // xxxxxxxxxx just testing....
   auto piece = new Piece();

   piece._color = CellState.CYAN;

   piece._grid.length = 4;
   foreach (ref col; piece._grid)
      col.length = 4;

   piece._grid[1][3] = true;
   piece._grid[2][0] = true;
   piece._grid[2][1] = true;
   piece._grid[2][2] = true;
   piece._grid[2][3] = true;

   return piece;
}

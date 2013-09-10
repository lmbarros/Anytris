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
 * A $(D Piece) has a bounding square with sides measuring $(D size)
 * blocks. This square defines a grid, in which every cell may contain a block
 * or be empty; you can access this grid using $(D grid).
 *
 * The bounding square mentioned in the previous paragraph is not necessarily
 * tight. In fact, typically, there is some space between the piece and some of
 * the square sides. To obtain the effective limits of the piece within the
 * grid, use $(D minX), $(D maxX), $(D minY) and $(D maxY).
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

   /**
    * The size of the piece bounding square; the number of blocks in each of its
    * sides.
    */
   public final @property size_t size() inout
   {
      return _grid.length;
   }

   /**
    * The square grid defining the piece.
    *
    * Indexing is consistent with the playfield: the first index is the row, the
    * second is the column. Also consistently with the playfield, indexing is
    * done as $(D grid[row][column].
    *
    * $(D true) marks filled blocks, $(D false) marks empty spaces.
    */
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

   /// The piece's horizontal coordinate.
   public @property uint x() inout
   {
      return _x;
   }

   /// Ditto
   public @property void x(uint value)
   {
      _x = value;
   }

   /// Ditto
   private uint _x;

   /// The piece's vertical coordinate.
   public @property uint y() inout
   {
      return _y;
   }

   /// Ditto
   public @property void y(uint value)
   {
      _y = value;
   }

   /// Ditto
   private uint _y;

   /// The smallest horizontal coordinate within $(D grid) with a block.
   public @property size_t minX() inout
   {
      return _minX;
   }

   /// Ditto
   private size_t _minX;

   /// The largest horizontal coordinate within $(D grid) with a block.
   public @property size_t maxX() inout
   {
      return _maxX;
   }

   /// Ditto
   private size_t _maxX;

   /// The smallest vertical coordinate within $(D grid) with a block.
   public @property size_t minY() inout
   {
      return _minY;
   }

   /// Ditto
   private size_t _minY;

   /// The largest vertical coordinate within $(D grid) with a block.
   public @property size_t maxY() inout
   {
      return _maxY;
   }

   /// Ditto
   private size_t _maxY;

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

   piece._grid[3][1] = true;
   piece._grid[0][2] = true;
   piece._grid[1][2] = true;
   piece._grid[2][2] = true;
   piece._grid[3][2] = true;

   piece._minX = 1;
   piece._maxX = 2;
   piece._minY = 0;
   piece._maxY = 3;

   return piece;
}

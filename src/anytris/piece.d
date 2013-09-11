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
   /**
    * Constructs the piece.
    *
    * Parameters:
    *    size = The "size" of the piece -- in fact, the size of one of the sides
    *       of its bounding square.
    */
   public this(uint size)
   {
      // Allocate the grid
      _grid.length = size;
      foreach (ref col; _grid)
         col.length = size;

      // Use a random color
      _color = randomColor;
   }

   /// Partially clones $(D _piece), in preparation for a rotation.
   private final Piece partialPieceCloneForRotation()
   {
      auto piece = new Piece(size);

      piece._color = _color;
      piece._x = _x;
      piece._y = _y;

      return piece;
   }

   /// Returns a copy of this piece, rotated in the clockwise direction.
   public final @property Piece clockwise()
   {
      auto piece = partialPieceCloneForRotation;
      auto srcY = size - 1;
      auto srcX = 0;
      foreach(i; 0..size)
      {
         foreach(j; 0..size)
         {
            piece._grid[i][j] = _grid[srcX][srcY];
            ++srcX;
         }

         --srcY;
         srcX = 0;
      }

      piece.setMinsMaxs();

      return piece;
   }

   /// Returns a copy of this piece, rotated in the counter-clockwise direction.
   public final @property Piece counterClockwise()
   {
      auto piece = partialPieceCloneForRotation;
      auto srcY = 0;
      auto srcX = size - 1;
      foreach(i; 0..size)
      {
         foreach(j; 0..size)
         {
            piece._grid[i][j] = _grid[srcX][srcY];
            --srcX;
         }

         ++srcY;
         srcX = size - 1;
      }

      piece.setMinsMaxs();

      return piece;
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
    * Computes and sets the $(D _minX), $(D _maxX), $(D _minY) and $(D _maxY)
    * fields.
    */
   public final void setMinsMaxs()
   {
      _minX = _minY = size - 1;
      _maxX = _maxY = 0;

      foreach(y; 0..size) foreach(x; 0..size)
      {
         if (grid[y][x])
         {
            if (x < _minX) _minX = x;
            if (x > _maxX) _maxX = x;
            if (y < _minY) _minY = y;
            if (y > _maxY) _maxY = y;
         }
      }
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
   public @property int x() inout
   {
      return _x;
   }

   /// Ditto
   public @property void x(int value)
   {
      _x = value;
   }

   /// Ditto
   private int _x;

   /// The piece's vertical coordinate.
   public @property int y() inout
   {
      return _y;
   }

   /// Ditto
   public @property void y(int value)
   {
      _y = value;
   }

   /// Ditto
   private int _y;

   /// The smallest horizontal coordinate within $(D grid) with a block.
   public @property int minX() inout
   {
      return _minX;
   }

   /// Ditto
   private int _minX;

   /// The largest horizontal coordinate within $(D grid) with a block.
   public @property int maxX() inout
   {
      return _maxX;
   }

   /// Ditto
   private int _maxX;

   /// The smallest vertical coordinate within $(D grid) with a block.
   public @property int minY() inout
   {
      return _minY;
   }

   /// Ditto
   private int _minY;

   /// The largest vertical coordinate within $(D grid) with a block.
   public @property int maxY() inout
   {
      return _maxY;
   }

   /// Ditto
   private int _maxY;

   /// Ditto
   CellState _color;
}


/// Creates and returns a random piece of $(D numBlocks) blocks.
public Piece makePiece(uint numBlocks)
{
   // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   // xxxxxxxxxx just testing....
   auto piece = new Piece(4);

   piece._grid[3][1] = true;
   piece._grid[0][2] = true;
   piece._grid[1][2] = true;
   piece._grid[2][2] = true;
   piece._grid[3][2] = true;

   piece.setMinsMaxs();

   return piece;
}

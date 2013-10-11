/**
 * The game logic, rules and execution.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.game;

import std.algorithm;
import anytris.cell_state;
import anytris.constants;
import anytris.piece;


/// Time, in seconds, to drop the piece by one row.
private enum dropTime = 0.5;


/**
 * Are the given coordinates valid playfield coordinates?
 *
 * In other words: can we use them to index $(_playfield)?
 */
private bool validPlayfieldCoords(int y, int x)
{
   return x >= 0
      && x < PLAYFIELD_WIDTH
      && y >= 0
      && y < PLAYFIELD_HEIGHT;
}


/// The game logic, rules and execution.
public class Game
{
   /**
    * Constructs the $(D Game).
    *
    * Parameters:
    *    numBlocksPerPiece = Number of blocks to use when creating pieces.
    */
   public this(int numBlocksPerPiece)
   in
   {
      assert(numBlocksPerPiece > 0);
      assert(numBlocksPerPiece <= MAX_BLOCKS_PER_PIECE);
   }
   body
   {
      _numBlocksPerPiece = numBlocksPerPiece;
      createPiece();
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
      {
         dropPiece();
         _timeToDrop += dropTime;
      }

      return !_gameOver;
   }


   //
   // User command handlers
   //

   /// Moves the piece one cell to the left, if possible.
   public final void movePieceLeft()
   {
      // Cannot move beyond the playfield left limit
      if (_piece.x + _piece.minX <= 0)
         return;

      // Check for collisions with neighboring blocks
      if (pieceColliding(0, -1))
         return;

      // No collisions, move
      _piece.x = _piece.x - 1;
   }

   /// Moves the piece one cell to the right, if possible.
   public final void movePieceRight()
   {
      // Cannot move beyond the playfield right limit
      if (_piece.x + piece.maxX + 1 >= PLAYFIELD_WIDTH)
         return;

      // Check for collisions with neighboring blocks
      if (pieceColliding(0, 1))
         return;

      // No collisions, move
      _piece.x = _piece.x + 1;
   }

   /// Rotates the piece in the clockwise direction.
   public final void rotatePieceCW()
   {
      auto newPiece = _piece.clockwise;

      auto goLeft = closestObstacleIsToTheRight();
      auto i = PLAYFIELD_WIDTH;
      while (--i > 0)
      {
         if (pieceFitsPlayfield(newPiece))
            _piece = newPiece;
         else
            newPiece.x = newPiece.x + (goLeft ? -1 : +1);
      }
   }

   /// Rotates the piece in the counter-clockwise direction.
   public final void rotatePieceCCW()
   {
      auto newPiece = _piece.counterClockwise;

      auto goLeft = closestObstacleIsToTheRight();
      auto i = PLAYFIELD_WIDTH;
      while (--i > 0)
      {
         if (pieceFitsPlayfield(newPiece))
            _piece = newPiece;
         else
            newPiece.x = newPiece.x + (goLeft ? -1 : +1);
      }
   }

   /// Drops the piece one block (AKA soft drop).
   public final void softDrop()
   {
      dropPiece();
      _timeToDrop = dropTime;
   }

   /// Drops the piece until it locks in place.
   public final void hardDrop()
   {
      while (dropPiece())
         continue;

      _timeToDrop = dropTime;
   }


   //
   // Game mechanics
   //

   /// Creates a new piece and make it fall.
   private final void createPiece()
   {
      _piece = makePiece(_numBlocksPerPiece);
      _piece.x = 0;
      _piece.y = PLAYFIELD_VISIBLE_HEIGHT;
   }

   /// Checks for lines clears and handles them.
   private final void handleLineClears()
   {
      // Is a given line filled with blocks?
      bool isFilledLine(const ref CellState[PLAYFIELD_WIDTH] line)
      {
         foreach(cell; line)
         {
            if (cell == CellState.EMPTY)
               return false;
         }

         return true;
      }

      // Check every line, clear the complete ones
      auto i = 0;

      auto numClearedLines = 0;
      do
      {
         if (isFilledLine(_playfield[i]))
         {
            ++numClearedLines;

            // Move all lines down; top line is untouched
            foreach(j; i..PLAYFIELD_HEIGHT-1)
               _playfield[j] = _playfield[j + 1];

            // Ensure top line is empty
            foreach(j; 0..PLAYFIELD_WIDTH)
               _playfield[PLAYFIELD_HEIGHT-1][j] = CellState.EMPTY;
         }
         else
         {
            ++i;
         }
      }
      while(i < PLAYFIELD_HEIGHT);

      // Update the score
      if (numClearedLines > 0)
         _score += 2 ^^ (numClearedLines) * _level * _numBlocksPerPiece;
   }


   //
   // Assorted helpers
   //

   /// Does $(D piece), at its current coordinates, fit the playfield?
   public final bool pieceFitsPlayfield(const Piece piece)
   {
      foreach(i; 0..piece.size) foreach(j; 0..piece.size)
      {
         if (!piece.grid[i][j])
            continue;

         const pfy = piece.y + i;
         const pfx = piece.x + j;

         if (!validPlayfieldCoords(pfy, pfx)
             || _playfield[pfy][pfx] != CellState.EMPTY)
         {
            return false;
         }
      }

      return true;
   }

   /**
    * Drops a piece by one row, if possible.
    *
    * This does also does all the checks for game over, for filled rows
    * (including removing the filled rows), etc.
    *
    * Returns:
    *    $(D true) of the piece was actually dropped; $(D false) if it couldn't
    *    (because there was no space left in the playfield.)
    */
   private final bool dropPiece()
   {
      if (canDropPiece)
      {
         _piece.y = _piece.y - 1;
         return true;
      }
      else
      {
         if (piece.y >= PLAYFIELD_VISIBLE_HEIGHT)
         {
            _gameOver = true;
         }
         else
         {
            mergePieceWithPlayfield();
            handleLineClears();
            createPiece();
         }

         return false;
      }
   }

   /// Can the piece drop by one row without colliding with existing blocks?
   private final @property bool canDropPiece()
   {
      // If reached the bottom of the playfield, cannot drop
      if (_piece.y + piece.minY <= 0)
         return false;

      // If there is a playfield block below any block piece, cannot drop
      if (pieceColliding(-1, 0))
         return false;

      // Else, can drop
      return true;
   }

   /**
    * Adds the blocks forming the $(D _piece) to the playfield.
    *
    * Also sets $(D _piece) to $(D null), just be sure that nobody will try to
    * use it again.
    */
   private final void mergePieceWithPlayfield()
   {
      const len = _piece.grid.length;
      foreach(i; 0..len) foreach(j; 0..len)
      {
         if (_piece.grid[i][j])
            _playfield[_piece.y + i][_piece.x + j] = _piece.color;
      }

      _piece = null;
   }

   /**
    * Checks if the piece will collide if trying to move in a given direction.
    *
    * The direction is given by the $(D dy) and $(D dx) parameters.
    */
   private final bool pieceColliding(int dy, int dx)
   {
      const len = cast(int)(_piece.grid.length);
      foreach(int i; 0..len) foreach(int j; 0..len)
      {
         if (!_piece.grid[i][j])
            continue;

         const pfy = _piece.y + i + dy;
         const pfx = _piece.x + j + dx;

         if (validPlayfieldCoords(pfy, pfx)
             && _playfield[pfy][pfx] != CellState.EMPTY)
         {
            return true;
         }
      }

      return false;
   }

   /**
    * Is the closest obstacle to $(D _piece) (either the playfield border or a
    * block) located to its right side?
    *
    * If not, it is to the left. Or, perhaps, equally distant of both sides, but
    * then it can be treated as being to the left anyway.
    */
   private final bool closestObstacleIsToTheRight()
   {
      // The limits of _piece's tight bounding square (in playfield coordinates,
      // intervals closed in both ends)
      const bbLeft = _piece.x + _piece.minX;
      const bbRight = _piece.x + _piece.maxX;
      const bbBottom = _piece.y + _piece.minY;
      const bbTop = _piece.y + _piece.maxY;

      // Find closest obstacle to the left
      auto leftDist = int.max;
      foreach (i; bbBottom..bbTop+1) foreach (j; -1..bbLeft)
      {
         if (!validPlayfieldCoords(i,j) || _playfield[i][j] != CellState.EMPTY)
            leftDist = min(leftDist, bbLeft - j);
      }

      // Find closest obstacle to the right
      auto rightDist = int.max;
      foreach (i; bbBottom..bbTop+1) foreach (j; bbRight..PLAYFIELD_WIDTH+1)
      {
         if (!validPlayfieldCoords(i,j) || _playfield[i][j] != CellState.EMPTY)
            rightDist = min(rightDist, j - bbRight);
      }

      // Voilà
      return rightDist < leftDist;
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
    * The blocks of the falling piece are not included here. (When the piece
    * locks in place, $(D mergePieceWithPlayfield()) is used to add its blocks
    * to the playfield.)
    */
   public final @property const(CellState[PLAYFIELD_WIDTH][PLAYFIELD_HEIGHT])
   playfield() inout
   {
      return _playfield;
   }

   /// Ditto
   private CellState[PLAYFIELD_WIDTH][PLAYFIELD_HEIGHT] _playfield;

   /// The falling piece.
   public final @property const(Piece) piece() inout
   {
      return _piece;
   }

   /// The game level.
   public @property int level() inout
   {
      return _level;
   }

   /// Ditto
   private int _level = 1;

   /// The game score.
   public @property int score() inout
   {
      return _score;
   }

   /// Ditto
   private int _score = 0;

   /// The number of blocks used to make the pieces.
   private const int _numBlocksPerPiece;

   /// Ditto
   private Piece _piece;

   /// Time remaining until the next time the piece drops one row.
   private double _timeToDrop = dropTime;

   /// Is the game over?
   private bool _gameOver = false;
}

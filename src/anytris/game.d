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
private enum dropTime = 0.2;


/// The states the piece can be in.
private enum PieceState
{
   /// Piece is falling.
   FALLING,

   /**
    * Piece is touching blocks underneath it. It still can be moved one block
    * left or right until it locks in place.
    */
   TOUCHING,
}


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
   /// Constructs the $(D Game).
   public this()
   {
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

   /// Creates a new piece and make it fall.
   private final void createPiece()
   {
      _piece = makePiece(0);
      _piece.x = 0;
      _piece.y = PLAYFIELD_VISIBLE_HEIGHT;
   }

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

   /// Rotates the piece in the clockwise direction.
   public final void rotatePieceCW()
   {
      auto newPiece = _piece.clockwise;
      if (pieceFitsPlayfield(newPiece))
         _piece = newPiece;
   }

   /// Rotates the piece in the counter-clockwise direction.
   public final void rotatePieceCCW()
   {
      auto newPiece = _piece.counterClockwise;
      if (pieceFitsPlayfield(newPiece))
         _piece = newPiece;
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
      {
         _piece.y = _piece.y - 1;
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
      foreach(i, line; _playfield)
      {
         if (isFilledLine(line))
         {
            // Move all lines down; top line is untouched
            foreach(j; i..PLAYFIELD_HEIGHT-1)
               _playfield[j] = _playfield[j + 1];

            // Ensure top line is empty
            foreach(j; 0..PLAYFIELD_WIDTH)
               _playfield[PLAYFIELD_HEIGHT-1][j] = CellState.EMPTY;
         }
      }
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
      const len = _piece.grid.length;
      foreach(i; 0..len) foreach(j; 0..len)
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

   /// The piece state.
   private PieceState _pieceState;

   /// Time remaining until the next time the piece drops one row.
   private double _timeToDrop = dropTime;

   /// Is the game over?
   private bool _gameOver = false;
}

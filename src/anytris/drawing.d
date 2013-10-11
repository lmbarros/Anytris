/**
 * Drawing routines.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.drawing;

import std.conv;
import std.string;
import fewdee.all;
import anytris.cell_state;
import anytris.constants;
import anytris.game;
import anytris.piece;


/// The array of the $(D Color)s a block can be, indexed by $(D BlockColor).
private Color[CellState.COUNT] blockColors;


/// Initializes $(D blockColors).
private static this()
{
   with (CellState)
   {
      blockColors[RED].baseColor = [ 0.9, 0.2, 0.2 ];
      blockColors[GREEN].baseColor = [ 0.2, 0.9, 0.2 ];
      blockColors[BLUE].baseColor = [ 0.2, 0.2, 0.9 ];
      blockColors[YELLOW].baseColor = [ 0.9, 0.9, 0.2 ];
      blockColors[PINK].baseColor = [ 0.9, 0.2, 0.9 ];
      blockColors[CYAN].baseColor = [ 0.2, 0.9, 0.9 ];
   }
}


/// Draws a block of a given color at the given screen coordinates.
private void drawBlockScreen(float x, float y, CellState color)
in
{
   assert(color < CellState.COUNT);
   assert(color != CellState.EMPTY);
}
body
{
   static Bitmap bmp;
   if (bmp is null)
      bmp = ResourceManager.bitmaps["block"];

   al_draw_tinted_bitmap(bmp, blockColors[color], x, y, 0);
}


/**
 * Draws a block of a given color at the given playfield coordinates.
 *
 * Passing a $(D y) coordinate larger than the playfield area (or in the vanish
 * areas) is OK -- the block will not be actually drawn in this case.
 */
private void drawBlockPlayfield(int y, int x, CellState color)
in
{
   assert(y >= 0);
   assert(x >= 0);
   assert(x < PLAYFIELD_WIDTH);
}
body
{
   if (y >= PLAYFIELD_HEIGHT - PLAYFIELD_VANISH_ZONE)
      return;

   drawBlockScreen(PLAYFIELD_LEFT + x * BLOCK_SIZE,
                   PLAYFIELD_TOP
                      + (PLAYFIELD_VISIBLE_HEIGHT - y - 1)
                      * BLOCK_SIZE,
                   color);
}


/// Draw the piece in the playfield, at its current coordinates.
private void draw(const Piece piece)
{
   enum s = BLOCK_SIZE;
   foreach(int i, row; piece.grid)
   {
      foreach(int j, cell; row)
      {
         if (cell)
            drawBlockPlayfield(piece.y + i, piece.x + j, piece.color);
      }
   }
}


/// Draws the whole screen, according to the $(D game) state.
public void draw(const Game game)
{
   void drawLabel(string text, float x, float y)
   body
   {
      const font = ResourceManager.fonts["labels"];
      al_draw_text(font, al_map_rgb(255, 255, 255), x, y, ALLEGRO_ALIGN_LEFT,
                   text.toStringz);
   }


   // Background and text labels
   al_draw_bitmap(ResourceManager.bitmaps["playfield"], 0.0, 0.0, 0);
   drawLabel("Next", 575, 80);
   drawLabel("Score", 575, 390);
   drawLabel("Level", 575, 485);
   drawLabel(to!string(game.score), 575, 432);
   drawLabel(to!string(game.level), 575, 527);

   // The blocks
   foreach(int i, row; game.playfield)
   {
      foreach(int j, state; row)
      {
         if (state != CellState.EMPTY)
            drawBlockPlayfield(i, j, state);
      }
   }

   // The piece
   game.piece.draw();
}

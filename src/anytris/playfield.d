/**
 * The playfield.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.playfield;

import std.random;
import fewdee.all;
import anytris.block;
import anytris.constants;


/**
 * The playfield -- the "well" where the pieces fall.
 *
 * The playfield has a certain height ($(D PLAYFIELD_HEIGHT)), but the top
 * portion ($(D PLAYFIELD_VANISH_ZONE) rows) is hidden.
 *
 * Playfield horizontal coordinates start at 0 (the left side) and grow towards
 * the right side. Vertical coordinates start at 0 (the top side) and grow
 * towards the bottom.
 */
class Playfield
{
   /// Constructs the playfield.
   public this()
   {
      _bmpBlock = ResourceManager.bitmaps["block"];

      foreach(i; 0..PLAYFIELD_WIDTH)
      {
         foreach(j; 0..PLAYFIELD_HEIGHT)
         {
            if (uniform(0.0, 1.0) < 0.5)
               _playfield[i][j] = new Block();
         }
      }
   }

   /**
    * Draws the playfield.
    *
    * TODO: I would like to avoid mixing game logic and drawing here.
    */
   public final void draw()
   {
      foreach(i; 0..PLAYFIELD_WIDTH)
      {
         foreach(j; PLAYFIELD_VANISH_ZONE..PLAYFIELD_HEIGHT)
         {
            if (_playfield[i][j])
            {
               _playfield[i][j].draw(
                  PLAYFIELD_LEFT + i * BLOCK_SIZE,
                  PLAYFIELD_TOP + (j - PLAYFIELD_VANISH_ZONE) * BLOCK_SIZE);
            }
         }
      }
   }

   /// The playfield itself. Empty cells are $(D null).
   private Block[PLAYFIELD_HEIGHT][PLAYFIELD_WIDTH] _playfield;

   /// The bitmap with the block that made up pieces.
   private Bitmap _bmpBlock;
}

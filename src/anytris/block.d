/**
 * Blocks are the little squares that make up the pieces.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.block;

import std.random;
import fewdee.all;
import anytris.constants;


/// The possible colors a block can have.
private enum BlockColor
{
   RED,
   GREEN,
   BLUE,
   YELLOW,
   PINK,
   CYAN,
   NUM_COLORS,
}


/// The array of the $(D Color)s a block can be, indexed by $(D BlockColor).
private Color[BlockColor.NUM_COLORS] blockColors;


/// Initializes $(D blockColors).
static this()
{
   with (BlockColor)
   {
      blockColors[RED].baseColor = [ 0.9, 0.2, 0.2 ];
      blockColors[GREEN].baseColor = [ 0.2, 0.9, 0.2 ];
      blockColors[BLUE].baseColor = [ 0.2, 0.2, 0.9 ];
      blockColors[YELLOW].baseColor = [ 0.9, 0.9, 0.2 ];
      blockColors[PINK].baseColor = [ 0.9, 0.2, 0.9 ];
      blockColors[CYAN].baseColor = [ 0.2, 0.9, 0.9 ];
   }
}


/**
 * A block is one of the little squares that make up the pieces.
 */
class Block
{
   /// Constructs the $(D Block).
   public this()
   {
      if (!_bmpBlock)
         _bmpBlock = ResourceManager.bitmaps["block"];

      _color = uniform(BlockColor.min, BlockColor.max);
   }

   /**
    * Draw the block at the given screen coordinates.
    *
    * TODO: Should I separate representation and drawing?
    */
   public final void draw(float x, float y)
   {
      al_draw_tinted_bitmap(_bmpBlock, blockColors[_color], x, y, 0);
   }

   /// Handy access to the block bitmap.
   private static Bitmap _bmpBlock;

   /// The block color; used as an index into $(D blockColors).
   private BlockColor _color;
}

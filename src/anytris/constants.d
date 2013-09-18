/**
 * Assorted Anytris constants.
 *
 * Ideally, this file contains only the constants that either are used in more
 * than one module, or that are expected to be changed as groups (I mean,
 * tweaking one constant would require tweaking some other constant, too).
 *
 * TODO:
 *    I guess that many constants here don't follow the rule I wrote above. I
 *    don't even know if that is a good rule.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.constants;

import fewdee.all;

public enum
{
   /// The window width, in pixels.
   WIN_WIDTH = 840,

   /// The window height, in pixels.
   WIN_HEIGHT = 630,

   /// The size, in pixels, of each of the square blocks that form the pieces.
   BLOCK_SIZE = 25,

   /// The position, in pixels, of the left side of the playfield on the screen.
   PLAYFIELD_LEFT = 295,

   /// The position, in pixels, of the top side of the playfield on the screen.
   PLAYFIELD_TOP = 65,

   /// The width of the playfield, in blocks
   PLAYFIELD_WIDTH = 10,

   /// The maximum allowed number of blocks per piece the game supports.
   MAX_BLOCKS_PER_PIECE = 10,

   /// The height of the vanish zone, in blocks.
   PLAYFIELD_VANISH_ZONE = MAX_BLOCKS_PER_PIECE,

   /// The height of the playfield, in blocks (including the vanish zone).
   PLAYFIELD_HEIGHT = 20 + PLAYFIELD_VANISH_ZONE,

   /**
    * The height of the visible playfield area (that is, excluding the vanish
    * zone).
    */
   PLAYFIELD_VISIBLE_HEIGHT = PLAYFIELD_HEIGHT - PLAYFIELD_VANISH_ZONE,
}

static assert(MAX_BLOCKS_PER_PIECE <= PLAYFIELD_WIDTH);
static assert(MAX_BLOCKS_PER_PIECE <= PLAYFIELD_HEIGHT);

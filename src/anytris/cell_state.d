/**
 * The states a playfield cell can be in.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.cell_state;


/// The states a playfield cell can be in.
public enum CellState
{
   EMPTY,  /// The cell is empty.
   RED,    /// The cell contains a red block.
   GREEN,  /// The cell contains a green block.
   BLUE,   /// The cell contains a blue block.
   YELLOW, /// The cell contains a yellow block.
   PINK,   /// The cell contains a pink block.
   CYAN,   /// The cell contains a cyan block.
   COUNT,  /// The number of cell states.
}

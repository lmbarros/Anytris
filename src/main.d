/**
 * AnyTris' entry point is here.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

import fewdee.all;
import anytris.constants;
import anytris.in_game_state;
import anytris.resources;


void main()
{
   al_run_allegro(
   {
      scope crank = new fewdee.engine.Crank();

      // Load resources
      loadResources();

      // Create display
      DisplayParams dp;
      dp.width = WIN_WIDTH;
      dp.height = WIN_HEIGHT;
      DisplayManager.createDisplay("main", dp);

      // Run!
      run(new InGameState());

      return 0;
   });
}

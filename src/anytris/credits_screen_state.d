/**
 * The "credits screen" state, which shows who did what.
 *
 * License: $(LINK2 http://opensource.org/licenses/zlib-license, Zlib License).
 *
 * Authors: Leandro Motta Barros
 */

module anytris.credits_screen_state;

import std.string;
import fewdee.all;
import anytris.drawing;


/// The "credits screen" state, which shows who did what.
public class CreditsScreenState: GameState
{
   /// Constructs the state.
   public this()
   {
      // Draw
      addHandler(
         FEWDEE_EVENT_DRAW,
         delegate(in ref ALLEGRO_EVENT event)
         {
            enum xNormal = 30;
            enum xIndent = 75;
            enum normalSkip = 60;
            enum smallSkip = 40;
            enum reallySmallSkip = 25;
            auto y = 30;

            al_clear_to_color(al_map_rgb_f(0.5, 0.15, 0.15));
            drawText("creditsTitle", "Credits", xNormal, y);

            y += normalSkip * 2;

            drawText(
               "creditsText", `Design and programming: Leandro Motta Barros`,
               xNormal, y);

            y += smallSkip;

            drawText(
               "creditsTextSmall", `Though Alexey Pajitnov, the original `
               `Tetris designer, probably deserves more credits.`,
               xIndent, y);

            y += smallSkip;

            drawText(
               "creditsTextSmall",
               `Anytris is licensed under the ZLib license.`,
               xIndent, y);

            y += smallSkip;

            drawText(
               "creditsTextSmall", `Anytris is written in the D programming `
               `language, using the FewDee library,`,
               xIndent, y);

            y += reallySmallSkip;

            drawText(
               "creditsTextSmall",
               `which uses the Allegro library under the hood.`,
               xIndent, y);

            y += normalSkip;

            drawText(
               "creditsText", `Music: Kevin MacLeod (incompetech.com)`,
               xNormal, y);

            y += smallSkip;

            drawText(
               "creditsTextSmall",
               `By the way, the songs are called "Padanaya Blokov" and `
               `"Miri's Magic Dance",`,
               xIndent, y);

            y += reallySmallSkip;

            drawText(
               "creditsTextSmall",
               ` and are licensed under CC BY 3.0.`,
               xIndent, y);

            y += normalSkip;

            drawText(
               "creditsText",
               `Fonts: Łukasz Dziedzic`,
               xNormal, y);

            y += smallSkip;

            drawText(
               "creditsTextSmall",
               `Anytris uses the "Lato" fonts, licensed under the OFL 1.1.`,
               xIndent, y);
         });

      // Handle key down events
      addHandler(ALLEGRO_EVENT_KEY_DOWN,
                 delegate(in ref ALLEGRO_EVENT event)
                 {
                    popState();
                 });
   }
}

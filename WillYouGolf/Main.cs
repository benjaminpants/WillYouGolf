using GmmlPatcher;
using GmmlHooker;
using UndertaleModLib;
using UndertaleModLib.Models;
using System.Linq;
using System;
using WysApi.Api;
using System.IO;
using UndertaleModLib.Decompiler;
using System.Reflection;
using TSIMPH;
using WYSCustomCharacterAPI;

namespace WillYouGolf
{
    public class GameMakerMod : IGameMakerMod
    {
        public static Dictionary<string, string> GMLkvp = new Dictionary<string, string>();
        

        public void Load(int audioGroup, UndertaleData data, ModData currentmod)
        {
            string soundsfolder = Path.Combine(currentmod.path, "Sounds");
            Conviences.AddAudioFolder(audioGroup, 1, soundsfolder, data);
            Conviences.AddAudioFolder(audioGroup, 2, Path.Combine(soundsfolder, "Music"), data);
            if (audioGroup != 0) return;
            string gmlfolder = Path.Combine(currentmod.path, "GMLSource");
            string charactersfolder = Path.Combine(currentmod.path, "Characters");
            GMLkvp.LoadGMLFolder(gmlfolder);
            WYSCustomCharacterAPI.GameMakerMod.DefaultCharacterID = "golfball";
            WYSCustomCharacterAPI.GameMakerMod.DisabledIDs.Add("shelly");
            WYSCustomCharacterAPI.GameMakerMod.DisabledIDs.Add("shellyclassic");
            WYSCustomCharacterAPI.GameMakerMod.DisabledIDs.Add("brokendrone");
            WYSCustomCharacterAPI.GameMakerMod.LoadCustomCharacters(charactersfolder);
            data.GameObjects.ByName("obj_player").EventHandlerFor(EventType.Draw, EventSubtypeDraw.DrawGUI, data.Strings, data.Code, data.CodeLocals)
                .AppendGmlSafe(GMLkvp["DrawPuckGUI"], data);
            data.GameObjects.ByName("obj_music_credits").EventHandlerFor(EventType.Other, EventSubtypeOther.User0, data.Strings, data.Code, data.CodeLocals)
                .AppendGmlSafe("play_music = mus_GOLFCREDITS", data);

            data.HookCode("gml_Object_obj_input_overrider_end_Other_10", GMLkvp["obj_input_overrider_end_Other_10"]);

            data.HookFunction("scr_ai_set_difficulty_multi", 
            @"
            #orig#()
            setting_air_cat_probability = 0
	        setting_fireworks_probability = 0");

        }
    }
}
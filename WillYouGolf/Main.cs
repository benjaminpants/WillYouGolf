﻿using GmmlPatcher;
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
        public static int golfhitsound = -1;

        public static Dictionary<string, string> GMLkvp = new Dictionary<string, string>();
        

        public void Load(int audioGroup, ModData currentmod)
        {
            UndertaleData data = Patcher.data;

            string soundsfolder = Path.Combine(currentmod.path, "Sounds");
            Conviences.AddAudioFolder(audioGroup, 1, soundsfolder);
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
                .AppendGMLSafe(GMLkvp["DrawPuckGUI"]);
            Hooker.HookFunction("scr_ai_set_difficulty_multi", 
            @"
            #orig#()
            setting_air_cat_probability = 0
	        setting_fireworks_probability = 0");
            
        }
    }
}
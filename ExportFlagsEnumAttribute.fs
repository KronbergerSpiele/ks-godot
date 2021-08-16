//adapted from https://gist.github.com/kleonc/a2bab51686ac6f4d7cb28aec88efa5d9
namespace KSUtil

open System
open System.Collections.Generic
open System.Linq
open Godot

[<AttributeUsage(AttributeTargets.Property ||| AttributeTargets.Field)>]
type ExportFlagsEnumAttribute(enumType: Type) = 
    inherit ExportAttribute(PropertyHint.Flags, ExportFlagsEnumAttribute.GetFlagsEnumHintString(enumType))
    static member public GetFlagsEnumHintString (enumType: Type): string =
        let flagNamesByFlag = new Dictionary<uint64, List<string>>()
        let mutable flag = uint64 1
        for name in Enum.GetNames enumType do
            let value = Convert.ToUInt64(Enum.Parse(enumType, name))
            while value > flag do
                if not (flagNamesByFlag.ContainsKey flag) then
                    flagNamesByFlag.Add(flag, new List<string>())
                flag <- flag <<< 1
            if value = flag then
                match flagNamesByFlag.TryGetValue flag with
                  | true, names -> names.Add name
                  | _  -> do
                    let names = new List<string>()
                    names.Add name
                    flagNamesByFlag.Add(flag, names)
        String.Join(", ", flagNamesByFlag.Values.Select(fun flagNames -> String.Join(" / ", flagNames)))
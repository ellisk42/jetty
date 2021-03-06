open Core.Std

open Expression
open Type
open Library
open Partial_evaluation
open Bottom_up
open Enumerate

(* consonants *)

type place = 
  | Bilabial
  | LabialDental
  | Interdental
  | Alveolar
  | AlveolarPalatal
  | Palatal
  | Velar
  | Glottal

type manner = 
  | Stop
  | Fricative
  | Nasal
  | Trill
  | Flap
  | Approximant
  | LateralApproximate
  | LateralFricative

type voice = Voiced | Unvoiced

type consonant = place * manner * voice

(* vowels *)
type vowel = 
  | V_E | V_i | V_I | V_ej | V_ae | V_ue | V_v | V_aj 
  | V_aw | V_a | V_u | V_uu | V_ow | V_c | V_cj

(* phonemes *)
type phone = Vowel of vowel | Consonant of consonant

let make_phonetic (n : string) : string = "/"^n^"/"

let make_consonant (n : string) (f : consonant) : expression = 
  Terminal(make_phonetic n,make_ground "phone",Obj.magic @@ ref @@ Consonant(f))

let make_vowel (n : string) (v : vowel) : expression = 
  Terminal(make_phonetic n,make_ground "phone",Obj.magic @@ ref @@ Vowel(v))

(* feature-based representation of phonemes *)
let c_Bilabial = Terminal("Bilabial",make_ground "place",Obj.magic @@ ref Bilabial);;
let c_LabialDental = Terminal("LabialDental",make_ground "place",Obj.magic @@ ref LabialDental);;
let c_Interdental = Terminal("Interdental",make_ground "place",Obj.magic @@ ref Interdental);;
let c_Alveolar = Terminal("Alveolar",make_ground "place",Obj.magic @@ ref Alveolar);;
let c_AlveolarPalatal = Terminal("AlveolarPalatal",make_ground "place",Obj.magic @@ ref AlveolarPalatal);;
let c_Palatal = Terminal("Palatal",make_ground "place",Obj.magic @@ ref Palatal);;
let c_Velar = Terminal("Velar",make_ground "place",Obj.magic @@ ref Velar);;
let c_Glottal = Terminal("Glottal",make_ground "place",Obj.magic @@ ref Glottal);;
let c_Stop = Terminal("Stop",make_ground "manner",Obj.magic @@ ref Stop);;
let c_Fricative = Terminal("Fricative",make_ground "manner",Obj.magic @@ ref Fricative);;
let c_Nasal = Terminal("Nasal",make_ground "manner",Obj.magic @@ ref Nasal);;
let c_Trill = Terminal("Trill",make_ground "manner",Obj.magic @@ ref Trill);;
let c_Flap = Terminal("Flap",make_ground "manner",Obj.magic @@ ref Flap);;
let c_Approximant = Terminal("Approximant",make_ground "manner",Obj.magic @@ ref Approximant);;
let c_LateralApproximate = Terminal("LateralApproximate",make_ground "manner",Obj.magic @@ ref LateralApproximate);;
let c_LateralFricative = Terminal("LateralFricative",make_ground "manner",Obj.magic @@ ref LateralFricative);;
let c_Voiced = Terminal("Voiced",make_ground "voice",Obj.magic @@ ref Voiced);;
let c_Unvoiced = Terminal("Unvoiced",make_ground "voice",Obj.magic @@ ref Unvoiced);;

let phonetic_features = [c_Bilabial;c_LabialDental;c_Interdental;c_Alveolar;c_AlveolarPalatal;c_Palatal;
                        c_Velar;c_Glottal;c_Stop;c_Fricative;c_Nasal;c_Trill;c_Flap;c_Approximant;
                        c_LateralApproximate;c_LateralFricative;c_Voiced;c_Unvoiced;];;
let c_consonant = Terminal("consonant",make_ground "place" @> make_ground "manner" @> make_ground "voice" @> 
                                       make_ground "phone",
                          lift_trinary @@ fun p m v ->
                          Consonant(p,m,v));;
let c_voice = Terminal("voice",make_ground "phone" @> make_ground "voice",
                       Obj.magic @@ ref @@ fun p -> match p with
  | None -> None
  | Some(Consonant(_,_,v)) -> Some(v)
  | Some(Vowel(_)) -> Some(Voiced));;
register_terminals [c_consonant;c_voice];;


(* library entries *)
let c_p = make_consonant "p" (Bilabial,Stop,Unvoiced);;
let c_b = make_consonant "b" (Bilabial,Stop,Voiced);;
let c_f = make_consonant "f" (LabialDental,Fricative,Unvoiced);;
let c_v = make_consonant "v" (LabialDental,Fricative,Voiced);;
let c_th = make_consonant "th" (Interdental,Fricative,Unvoiced);;
let c_Th = make_consonant "Th" (Interdental,Fricative,Voiced);;
let c_ut = make_consonant "ut" (Alveolar,Approximant,Voiced);;
let c_q = make_consonant "?" (Glottal,Stop,Unvoiced);;
let c_h = make_consonant "h" (Glottal,Fricative,Unvoiced);;
let c_s = make_consonant "s" (Alveolar,Fricative,Unvoiced);;
let c_z = make_consonant "z" (Alveolar,Fricative,Voiced);;
let c_sh = make_consonant "sh" (AlveolarPalatal,Fricative,Unvoiced);;
let c_zh = make_consonant "zh" (AlveolarPalatal,Fricative,Voiced);;
let c_j = make_consonant "j" (Palatal,Approximant,Voiced);;
let c_t = make_consonant "t" (Alveolar,Stop,Unvoiced);;
let c_d = make_consonant "d" (Alveolar,Stop,Voiced);;
let c_r = make_consonant "r" (Alveolar,Approximant,Voiced);;
let c_ng = make_consonant "ng" (Velar,Nasal,Voiced);;
let c_n = make_consonant "n" (Alveolar,Nasal,Voiced);;
let c_m = make_consonant "m" (Bilabial,Nasal,Voiced);;
let c_k = make_consonant "k" (Velar,Stop,Unvoiced);;
let c_g = make_consonant "g" (Velar,Stop,Voiced);;
let c_uw = make_consonant "uw" (Bilabial,Approximant,Unvoiced);;
let c_w = make_consonant "w" (Bilabial,Approximant,Voiced);;
let c_lo = make_consonant "lo" (Alveolar,LateralApproximate,Unvoiced);;
let c_l = make_consonant "l" (Alveolar,LateralApproximate,Voiced);;
let v_ej = make_vowel "ej" V_ej;;
let v_E = make_vowel "E" V_E;;
let v_ue = make_vowel "ue" V_ue;;
let v_i = make_vowel "i" V_i;;
let v_I = make_vowel "I" V_I;;
let v_v = make_vowel "vv" V_v;;
let v_ae = make_vowel "ae" V_ae;;
let v_ow = make_vowel "ow" V_ow;;
let v_a = make_vowel "a" V_a;;
let v_aj = make_vowel "aj" V_aj;;
let v_aw = make_vowel "aw" V_aw;;
let v_c = make_vowel "c" V_c;;
let v_cj = make_vowel "cj" V_cj;;
let v_u = make_vowel "u" V_u;;
let v_uu = make_vowel "uu" V_uu;;

let phone_consonants = [c_s;c_z;c_t;c_d;c_r;c_n;c_m;c_k;c_g;c_w;c_l;c_p;c_b;c_f;c_v;c_th;c_Th;c_ut;c_q;c_h;
                        c_sh;c_zh;c_j;c_ng;c_uw;c_lo;];;
let phone_vowels = [v_a;v_ej;v_E;v_ue;v_i;v_ae;v_ow;v_I;v_v;v_aj;v_aw;v_c;v_u;v_uu;];;
let phones = phone_consonants @ phone_vowels;;

let terminal_phone (p : phone) = 
  match List.find phones (fun q -> p = !(Obj.magic @@ terminal_thing q)) with
  | Some(s) -> s
  | _ -> raise (Failure "terminal_phone: unknown phone");;

let strident = function
  | Consonant(Alveolar,Fricative,_) -> true
  | Consonant(AlveolarPalatal,Fricative,_) -> true
  | _ -> false

let front_vowel = function
  | Vowel(V_i) -> true
  | Vowel(V_I) -> true
  | Vowel(V_E) -> true
  | Vowel(V_ej) -> true
  | Vowel(V_ae) -> true
  | _ -> false

let is_voiced = function
  | Consonant(_,_,Unvoiced) -> false
  | _ -> true

let transfer_voice p1 p2 = 
  match (p1,p2) with
  | (Consonant(p,m,_), Consonant(_,_,v)) -> Consonant(p,m,v)
  | (Consonant(p,m,_), Vowel(_)) -> Consonant(p,m,Voiced)
  | _ -> p2


let l_transfer_voice = Terminal("transfer-voice",
                                make_arrow (make_ground "phone")
                                  (make_arrow (make_ground "phone") (make_ground "phone")),
                                lift_binary transfer_voice 
                               );;
register_primitive "transfer-voice" [phones;phones] (fun arguments -> 
    try
      match arguments with
      | [Some(thing_one);Some(thing_to)] -> 
        Some(terminal_phone (transfer_voice !(Obj.magic thing_one) !(Obj.magic thing_to)))
      | _ -> None
    with _ -> None)

let l_strident = Terminal("strident", t1 @> t1 @> (make_ground "phone") @> t1,
                          lift_reversed_predicate strident
                         );;
register_terminal l_strident;;
let l_front_vowel = Terminal("front-vowel", t1 @> t1 @> (make_ground "phone") @> t1,
                          lift_reversed_predicate front_vowel
                         );;
register_terminal l_front_vowel;;
(* 
register_primitive "strident" [phones;] (fun arguments -> 
    try
      match arguments with
      | [Some(p);] -> 
        Some(if strident !(Obj.magic p) then c_K else c_F)
      | _ -> None
    with _ -> None)
 *)

let l_is_voiced = Terminal("is-voiced", t1 @> t1 @> make_ground "phone" @> t1,
                          lift_reversed_predicate is_voiced
                         );;
register_terminal l_is_voiced;;
(* register_primitive "is-voiced" [phones;] (fun arguments -> 
    try
      match arguments with
      | [Some(p);] -> 
        Some(if is_voiced !(Obj.magic p) then c_K else c_F)
      | _ -> None
    with _ -> None)
*)
let feature_terminals = [c_S;c_B;c_C;c_I;(* c_K;c_F; *)
                         c_null;c_append;c_rcons;c_cons;c_last_one;
                         c_consonant;c_voice;l_strident;l_front_vowel]
                         @ phonetic_features @ phone_vowels;;
let phonetic_terminals = [c_S;c_B;c_C;c_I;(* c_K;c_F; *)
                         c_null;c_append;c_cons;c_last_one;
                         (*l_transfer_voice;*)l_is_voiced;l_strident;l_front_vowel]
                         @ phones;;
register_terminals phonetic_terminals;;
register_terminals phonetic_features;;
register_terminals [l_transfer_voice;];;

(* are 2 phonemes similar enough that we should consider using one to search for the other? *)
let phonetic_neighbors p1 p2 = 
  match (p1,p2) with
  | (Consonant(x1,y1,_),Consonant(x2,y2,_)) when x1 = x2 && y1 = y2 -> true
  | (Vowel(v1),Vowel(v2)) when v1 = v2 -> true
  | _ -> false

(* creates a constant string of phonemes *)
let make_phonetic (s : string) : expression = 
  let rec slurp start_index = 
    if start_index >= String.length s
    then c_null
    else
      let end_index = match String.index_from s start_index ' '  with
      | Some(i) -> i
      | None -> String.length s
      in
      let substring = make_phonetic @@ String.sub s start_index (end_index - start_index) in
      match List.find phones (fun p -> substring = string_of_expression p) with
      | Some(p) -> 
        Application(Application(c_cons,p),
                    slurp (end_index+1))
      | None -> raise (Failure("unknown phone: "^substring))
  in slurp 0

let test_phonetics () = 
  Printf.printf "%s\n" (string_of_expression @@ make_phonetic "s i d");
  Printf.printf "%s\n" (string_of_expression @@ make_phonetic "s ae d");
  Printf.printf "%s\n" (string_of_expression @@ make_phonetic "s i ae z");
  Printf.printf "%s\n" (string_of_expression @@ make_phonetic "z");
  Printf.printf "%s\n" (string_of_expression @@ make_phonetic "ae");;

(* test_phonetics ();; *)
(*let test_templates () = 
  List.iter [l_strident;l_transfer_voice;c_I;c_F;c_K;c_C;c_S;c_B;c_append;c_last_one;] (fun c -> 
    List.iter (get_templates c (infer_type c)) (fun (target,template) -> 
        Printf.printf "%s ---> %s" (string_of_expression target) (string_of_expression template);
        print_newline ()));;
*)

(* test_templates ();; *)

let test_backwards () = 
  let dagger = make_expression_graph 1000 in
  let l = make_flat_library @@ phones @ [c_append;c_cons;c_null;] in
  List.iter (snd l) (fun (e,_) -> 
      ignore(insert_expression dagger e));
  let rewrites = List.map (snd l) (fun (e,(_,t)) -> 
      (* load primitives into the graph *)
      ignore(insert_expression dagger e);
      List.map (get_templates e t) (fun (target,template) -> 
          (* Printf.printf "%s  <>  %s\n" (string_of_expression target) (string_of_expression template); *)
          (template,apply_template target)))
                 |> List.concat 
  in 
  backward_enumerate dagger l rewrites 1000 500 (TCon("list",[make_ground "phone"]))
    (insert_expression dagger @@ make_phonetic "h E v i ue s t") |> 
  List.iter ~f:(fun (e,_) -> 
    Printf.printf "%s\n" @@ string_of_expression @@ extract_expression dagger e);;


(*test_backwards ();;*)

let test_features () = 
  let learned = expression_of_string "((consonant Bilabial) Stop)" in
  (* ((B ((B ((consonant Bilabial) Stop)) voice)) last-one) *)
  let e = (expression_of_string @@ "((S (C rcons)) ((B ((B ((consonant Bilabial) Stop)) voice)) last-one))") in
  Printf.printf "%s\n" (string_of_expression e);
  let g = make_flat_library @@ learned :: feature_terminals in
  let t = (TCon("list",[list_type]) @> TCon("list",[list_type])) in
  Printf.printf "%f\n" @@ map_likelihood g t e;;

(*  match run_expression e with
  | Some(Consonant(Bilabial,Stop,Voiced)) -> Printf.printf "success\n";
  | _ -> Printf.printf "nooo\n";; *)

test_features ();;

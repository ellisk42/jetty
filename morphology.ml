open Core.Std

open Frontier
open Phonetics
open Ec
open Task
open Library
open Expression
open Type
open Utils
open Symbolic_dimensionality_reduction
open Noisy_reduction
open Em
open Enumerate
open Lambda_calculus
open Crp

(* most common adjective stems produced by thirty months old *)
let top_adjectives = [
  "k ow l d";
  "d ue r t i";
  "h a t";
  "w E t";
  "b I g";
  "b r ow k ue n";
  "k l i n";
  "g uu d";
  "h E v i";
  "j ue k i";
  "h ue ng g r i";
  "l I t ue l";
  "ue s l i p";
  "d r aj";
  "c r ue n d zh";
  "h ue r t";
  "b ae d";
  "h ae p i";
  "r E d";
  "b l u";
]

(* have comparative/superlative form *)
let comparable_adjectives = 
  (List.filter top_adjectives (* remove words without comparative form *)
     ~f:(not % List.mem ["b r ow k ue n";"g uu d";"ue s l i p";"h ue r t";])) @ ["g uu d"]

let top_comparative =
  List.map comparable_adjectives ~f:(fun w -> w ^ " ue r") @ ["b E t ue r"]

let top_superlative =
  (List.map comparable_adjectives ~f:(fun w -> w ^ " ue s t")) @ ["b E s t"]

(* most common verb stems produced by thirty months old *)
let top_verbs = [
  "i t";
  "g ow";
  "f a l";
  "h ue g";
  "k I s";
  "w a k";
  "l ue v";
  "w a sh";
  "k r aj";
  "l uu k";
  "ow p ue n";
  "p l ej";
  "d r I ng k";
  "r i d";
  "s l i p";
  "s t a p";
  "b aj t";
  "b l ow";
  "b r ej k";
  "h I t";
  "h ej l p";
  "l aj k";
  "k l ae p";
  "k ow m";
  "d ae n s";
  "t ej p";
  "th r ow";
  "sh aw ue r";
  "t I k ue l";
  "k I k";
  "k w ae k";
  "d r aj v";
  "s l aj d";
  "r aj d";
  "s w I m";
  "h ue r t";
  "s p I l";
  "sh a p";
  "s i";
  "w ue r k";
  "f I k s";
  "t ue t sh";
  "h aj d";
  "k l i n";
  "s I ng k";
  "f aj n d";
  "g ej t";
  "v ae k j u m";
  "t a k";
  "s I ng";
  "p ej n t";
]

(* remarkably regular *)
let top_gerunds =
  List.map top_verbs ~f:(fun v -> v ^ " I ng")

(* top verbs with case marking (3rd person singular present) *)
let top_case = [
  "i t s";
  "g ow z";
  "f a l z";
  "h ue g z";
  "k I s ue z";
  "w a k s";
  "l ue v z";
  "w a sh ue z";
  "k r aj z";
  "l uu k s";
  "ow p ue n z";
  "p l ej z";
  "d r I ng k s";
  "r i d z";
  "s l i p s";
  "s t a p s";
  "b aj t s";
  "b l ow z";
  "b r ej k s";
  "h I t s";
  "h ej l p s";
  "l aj k s";
  "k l ae p s";
  "k ow m z";
  "d ae n s ue z";
  "t ej p s";
  "th r ow z";
  "sh aw ue r z";
  "t I k ue l z";
  "k I k s";
  "k w ae k s";
  "d r aj v z";
  "s l aj d z";
  "r aj d z";
  "s w I m z";
  "h ue r t s";
  "s p I l z";
  "sh a p s";
  "s i z";
  "w ue r k s";
  "f I k s ue z";
  "t ue t sh ue z";
  "h aj d z";
  "k l i n z";
  "s I ng k s";
  "f aj n d z";
  "g ej t s";
  "v ae k j u m z";
  "t a k s";
  "s I ng z";
  "p ej n t s";
]

let top_past = [
  "ej t";
  "w E n t";
  "f E l";
  "h ue g d";
  "k I s t";
  "w a k t";
  "l ue v d";
  "w a sh t";
  "k r aj d";
  "l uu k t";
  "ow p ue n d";
  "p l ej d";
  "d r ae ng k";
  "r i d";
  "s l E p t";
  "s t a p t";
  "b I t";
  "b l u";
  "b r ow k";
  "h I t";
  "h ej l p t";
  "l aj k t";
  "k l ae p t";
  "k ow m d";
  "d ae n s t";
  "t ej p t";
  "th r u";
  "sh aw ue r d";
  "t I k ue l d";
  "k I k t";
  "k w ae k t";
  "d r ow v";
  "s l I d";
  "r ow d";
  "s w I m d";
  "h ue r t";
  "s p I l d";
  "sh a p t";
  "s a";
  "w ue r k t";
  "f I k s t";
  "t ue t sh t";
  "h I d";
  "k l i n d";
  "s ae ng k";
  "f aw n d";
  "g aw t";
  "v ae k j u m d";
  "t a k t";
  "s ej ng";
  "p ej n t ue d";
]

(* most common nouns produced by thirty months old *)
let top_nouns = [
  "b c l";
  "b ue b ue l z";
  "t sh i z";
  "k uu k i";
  "m I l k";
  "p ae n t s";
  "s a k";
  "a r m";
  "f uu t";
  "n ow z";
  "k i z";
  "l aj t";
  "w a t ue r";
  "s ow p";
  "d c r";
  "b ej b i";
  "b ae th";
  "b ue r d";
  "h c r s";
  "b aj s I k ue l";
  "k a r";
  "t r ue k";
  "b uu k";
  "b ue n ae n ae";
  "k r ae k ue r";
  "aj s k r i m";
  "p i t s ue";
  "sh u";
  "I r";
  "aj";
  "h E r";
  "t ow";
  "k ue p";
  "p I l ow";
  "t E l ue f ow n";
(*  "t u th b r ue sh";
  "b ae th ue b";
  "b E d";
  "t i v i";
  "th ae ng k j u"; *)
]

(* most common singular nouns produced by thirty months old *)
let top_singular = [
  "b c l";
  "b ue b ue l";
  "t sh i z";
  "k uu k i";
  "m I l k";
(*   "p ae n t s"; *)
  "s a k";
  "a r m";
(*   "f uu t"; *)
  "n ow z";
  "k i z";
  "l aj t";
(*   "w a t ue r"; *)
  "s ow p";
  "d c r";
  "b ej b i";
  "b ae th";
  "b ue r d";
  "h c r s";
  "b aj s I k ue l";
  "k a r";
  "t r ue k";
  "b uu k";
  "b ue n ae n ae";
  "k r ae k ue r";
  "aj s k r i m";
  "p i t s ue";
  "sh u";
  "I r";
  "aj";
  "h E r";
  "t ow";
  "k ue p";
  "p I l ow";
  "t E l ue f ow n";
  "t u th b r ue sh";
  "b ae th ue b";
  "b E d";
  "t i v i";
  "th ae ng k j u";
  "m a m i";
  "ae p ue l";
  "t ue m i";
  "g r ej p";
  "t r ej n";
  "b ue t ue n";
  "t sh ej r";
  "k I t i";
  "f l aw ue r";
  "b ej l i b ue t ue n";
  "s p u n";
  "d a g";
  "k I t sh ue n";
  "h ej d";
  "b ow l";
  "t c j";
  "p ej p ue r";
  "m aw th";
(*   "b ue t ue k s"; *)
  "b l ae ng k ue t";
  "sh ue r t";
  "k r ej a n";
  "ej r p l ej n";
  "d ue k";
  "b a t ue l";
  "t u th";
  "p ue p i";
  "l ej g";
  "h ae n d";
  "w I n d ow";
  "ej l ue f ue n t";
  "f c r k";
  "t ej b ue l";
  "t r i";
  "c r ue n d zh";
  "b ow t";
(*   "m ue n i"; *)
  "f I sh";
  "k ej k";
  "b ej r";
  "d aj p ue r";
(*   "s p ue g ej t i"; *)
  "ej g";
  "n i";
  "b ae th r u m";
  "p a t i";
  "r a k";
  "p ej n";
  "g r ae s";
(*   "aj s";
  "p a p k c r n"; *)
  "s w I ng";
  "t ej d i b ej r";
  "d r I ng k";
  "t sh I k ue n";
  "t ow s t";
  "s t r ow l ue r";
  "s I r i ue l";
  "h ow m";
  "h ae t";
]

(* most common singular nouns produced by thirty months old *)
let top_plural = [
  "b c l z";
  "b ue b ue l z";
  "t sh i z ue z";
  "k uu k i z";
  "m I l k s";
(*   "p ae n t s"; *)
  "s a k s";
  "a r m z";
(*   "f uu t"; *)
  "n ow z ue z";
  "k i z ue z";
  "l aj t s";
(*   "w a t ue r"; *)
  "s ow p s";
  "d c r z";
  "b ej b i z";
  "b ae th s";
  "b ue r d z";
  "h c r s ue z";
  "b aj s I k ue l z";
  "k a r z";
  "t r ue k s";
  "b uu k s";
  "b ue n ae n ae z";
  "k r ae k ue r z";
  "aj s k r i m z";
  "p i t s ue z";
  "sh u z";
  "I r z";
  "aj z";
  "h E r z";
  "t ow z";
  "k ue p s";
  "p I l ow z";
  "t E l ue f ow n z";
  "t u th b r ue sh ue s";
  "b ae th ue b z";
  "b E d z";
  "t i v i z";
  "th ae ng k j u z";
  "m a m i z";
  "ae p ue l z";
  "t ue m i z";
  "g r ej p s";
  "t r ej n z";
  "b ue t ue n z";
  "t sh ej r z";
  "k I t i z";
  "f l aw ue r z";
  "b ej l i b ue t ue n z";
  "s p u n z";
  "d a g z";
  "k I t sh ue n z";
  "h ej d z";
  "b ow l z";
  "t c j z";
  "p ej p ue r z";
  "m aw th s";
(*   "b ue t ue k s"; *)
  "b l ae ng k ue t s";
  "sh ue r t s";
  "k r ej a n z";
  "ej r p l ej n z";
  "d ue k s";
  "b a t ue l z";
  "t i th";
  "p ue p i z";
  "l ej g z";
  "h ae n d z";
  "w I n d ow z";
  "ej l ue f ue n t s";
  "f c r k s";
  "t ej b ue l z";
  "t r i z";
  "c r ue n d zh ue z";
  "b ow t s";
(*   "m ue n i"; *)
  "f I sh ue z";
  "k ej k s";
  "b ej r z";
  "d aj p ue r z";
(*   "s p ue g ej t i"; *)
  "ej g z";
  "n i z";
  "b ae th r u m z";
  "p a t i z";
  "r a k s";
  "p ej n z";
  "g r ae s ue z";
(*   "aj z";
  "p a p k c r n"; *)
  "s w I ng z";
  "t ej d i b ej r z";
  "d r I ng k s";
  "t sh I k ue n z";
  "t ow s t s";
  "s t r ow l ue r z";
  "s I r i ue l z";
  "h ow m z";
  "h ae t s";
]


let make_word_task word stem = 
  let word_parts = String.split word ' ' in
  let stem_parts = String.split stem ' ' in
  let e = make_phonetic word in
  let extras = 
    if string_proper_prefix stem word 
    then [(make_phonetic stem,0.);(make_phonetic @@ String.concat ~sep:" " @@ 
                                   List.drop word_parts @@ List.length stem_parts, 0.)]
    else [(make_phonetic word,0.)] 
  in
  let correct_phones : phone list = safe_get_some "make_work_task: None" @@ run_expression e in
  let prop = (fun e w -> w) in
  let ll e =
    match run_expression e with
    | Some(ps) when ps = correct_phones -> 0.0
    | _ -> Float.neg_infinity
  in
  { name = word; task_type = TCon("list",[make_ground "phone"]); 
    score = LogLikelihood(ll); proposal = Some(prop,extras); }

let make_word_regress_task word stem = 
  let e = make_phonetic word in
  let stem_phones = make_phonetic stem in
  let extras = 
    if string_proper_prefix stem word 
    then []
    else [(make_phonetic word,0.)] 
  in
  let correct_phones : phone list = safe_get_some "make_work_task: None" @@ run_expression e in
  let prop = (fun e w -> w) in
  let ll e =
    match run_expression (Application(e,stem_phones)) with
    | Some(ps) when ps = correct_phones -> 0.0
    | _ -> Float.neg_infinity
  in
  { name = word; task_type = TCon("list",[make_ground "phone"]) @> TCon("list",[make_ground "phone"]); 
    score = LogLikelihood(ll); proposal = None; (* Some(prop,extras); *) }

let strident_transform = 
  expression_of_string "((@ ?) (((strident ((cons /ue/) null)) null) (last-one ?)))" |> 
  remove_lambda "?"

let pluralize = 
  expression_of_string "((@ ?) (((is-voiced ((cons /z/) null)) ((cons /s/) null)) (last-one ?)))" |> 
  remove_lambda "?"

let weird_pluralize = 
  expression_of_string 
"((((is-voiced ((C @) ((cons /z/) null))) ((C @) ((cons /s/) null))) (last-one ?)) ?)" |> 
  remove_lambda "?"

let big_pluralize = 
  Application(Application(c_B,pluralize),strident_transform)

let pasteurize = 
  expression_of_string "((@ ?) (((is-voiced ((cons /d/) null)) ((cons /t/) null)) (last-one ?)))" |> 
  remove_lambda "?"

let weird_pasteurize = 
  expression_of_string "((((is-voiced ((C @) ((cons /d/) null))) ((C @) ((cons /t/) null))) (last-one ?)) ?)" |> 
  remove_lambda "?"

let morphology_learner stem transform = 
  (* Memory hack - limit to top 25 words *)
(*   let stem = List.take stem 25 in
  let transform = List.take transform 25 in  *)
  let name = Sys.argv.(1) in
  let frontier_size = Int.of_string Sys.argv.(2) in
  let tasks = 
    List.map2_exn transform stem make_word_task
  in
  let g0 = make_flat_library phonetic_terminals in
  let g = ref g0 in 
  if not (string_proper_prefix "grammars/" name) (* don't have a grammar provided for us, learn it *)
  then let lambda = Float.of_string Sys.argv.(3) in
    let alpha = Float.of_string Sys.argv.(4) in
    for i = 1 to 10 do
      Printf.printf "\n \n \n Iteration %i \n" i;
      g := expectation_maximization_iteration ("log/"^name^"_"^string_of_int i)
          lambda alpha frontier_size tasks (!g)
    done
  else g := load_library name;
  let decoder =
    noisy_reduce_symbolically g0 !g frontier_size tasks in
  Printf.printf "Decoder: %s\n" (string_of_expression decoder)
;;

let morphology_regress stem transform = 
  let name = Sys.argv.(1) in
  let basis = if 0 = String.compare Sys.argv.(2) "feature" then feature_terminals else phonetic_terminals in
  let frontier_size = Int.of_string Sys.argv.(3) in
  let tasks = 
    List.map2_exn transform stem make_word_regress_task
  in
  let g0 = make_flat_library basis in
  let g = ref g0 in 
  if not (string_proper_prefix "grammars/" name) (* don't have a grammar provided for us, learn it *)
  then let lambda = Float.of_string Sys.argv.(4) in
    let alpha = Float.of_string Sys.argv.(5) in
    let beta = Float.of_string Sys.argv.(6) in
    let ct = Int.of_string Sys.argv.(7) in
    let da = Float.of_string Sys.argv.(8) in
    for i = 1 to 5 do
      Printf.printf "\n \n \n Iteration %i \n" i;
      g := expectation_maximization_iteration ~compression_tries:ct ("log/"^name^"_"^string_of_int i)
          ~application_smoothing:beta ~da:da lambda alpha frontier_size tasks (!g)
    done
  else g := load_library name;
(*  let decoder =
    noisy_reduce_symbolically ~arity:0 g0 !g frontier_size tasks in
  Printf.printf "Decoder: %s\n" (string_of_expression decoder) *)
  Printf.printf "that's all folks\n"
;;

let morphology_Grapher stem transform g ds = 
  let ds = List.map ds ~f:expression_of_string in
  let g = load_library g in
  let tasks = List.map2_exn transform stem make_word_task in
  List.iter ds ~f:(fun d -> 
    noisy_decoder_posterior (make_flat_library phonetic_terminals) g 100000 tasks d ;
    Printf.printf "\n\n")
;;

let morphology_sampler stem transform = 
  let tasks = 
    List.map2_exn transform stem make_word_regress_task
  in
  let a = Float.of_string Sys.argv.(2) in  
  let iterations = Int.of_string Sys.argv.(3) in
  run_parallel_Gibbs a feature_terminals tasks iterations
;;

let super_decoders = [
  "I";
  "((C @) ((cons /ue/) ((cons /s/) ((cons /t/) null))))"];;
let plural_decoders = [
  "I";
  "((C @) ((cons /s/) null))";
  "((C @) ((cons /z/) null))";
  string_of_expression pluralize;];;
let past_decoders = [
  "I";
  "((C @) ((cons /t/) null))";
  "((C @) ((cons /d/) null))";
  string_of_expression pasteurize;];;


let choose_learner () = 
  print_arguments ();
  match Sys.argv.(1) with
  | "plural" -> morphology_learner top_singular top_plural
  | "regress_plural" -> morphology_regress top_singular top_plural
  | "grammars/plural" -> morphology_learner top_singular top_plural
  | "comparative" -> morphology_learner comparable_adjectives top_comparative
  | "superlative" -> morphology_learner comparable_adjectives top_superlative
  | "grammars/super" -> morphology_learner comparable_adjectives top_superlative
  | "gerund" -> morphology_learner top_verbs top_gerunds
  | "past" -> morphology_learner top_verbs top_past
  | "regress_past" -> morphology_regress top_verbs top_past
  | "past_sample" -> morphology_sampler top_verbs top_past
  | "grammars/regress_past_9_grammar" -> morphology_regress top_verbs top_past
  | "grammars/regress_past_1_grammar" -> morphology_regress top_verbs top_past
  | "grammars/past" -> morphology_learner top_verbs top_past
  | "case" -> morphology_learner top_verbs top_case
  | "plotSuper" -> morphology_Grapher comparable_adjectives top_superlative "grammars/super" super_decoders
  | "plotPast" -> morphology_Grapher top_verbs top_past "grammars/past" past_decoders
  | "plotPlural" -> morphology_Grapher top_singular top_plural "grammars/plural" plural_decoders
  | "plotBigPlural" -> morphology_Grapher top_singular top_plural "grammars/plural" 
                         [string_of_expression big_pluralize]
  | _ -> raise (Failure "morphology")
;;

choose_learner ();;

(* 
let () = 
  let g = load_library "log/regress_past_1_grammar" in
  Printf.printf "past regress: %f\n\n" (map_likelihood g (TCon("list",[list_type]) @> TCon("list",[list_type])) weird_pasteurize);;
 *)


let harmonize = 
  "((@ ?) ((((exists ((cons /E/) null)) ((cons /ue/) null)) front-vowel) ?))";;
let reduplication = 
  "((cons (car ?)) ((cons (car (cdr ?))) ?))";;
let arabic = 
  "((cons ?0) ((cons /a/) ((cons ?1) ((cons /i/) ((cons ?2) null)))))";;

(* 
let () = 
  let terms = phonetic_terminals @ [c_exists;c_car;c_cdr;] in
  let g = make_flat_library terms in 
  let t = (TCon("list",[list_type]) @> TCon("list",[list_type])) in
  List.iter [harmonize;reduplication] ~f:(fun e -> 
      let cl = remove_lambda "?" (expression_of_string e) in
      let db = indexed_of_string @@  "(% " ^ String.tr ~target:'?' ~replacement:'0' e ^ ")" in
      
      Printf.printf "%f vs %f\n" (map_likelihood g t cl) (indexed_likelihood (log 0.4, log 0.09, terms) t db);
      flush stdout
    );
  let cl = expression_of_string arabic  |> remove_lambda "?2" |> remove_lambda "?1"|> remove_lambda "?0" in
  let db = indexed_of_string @@  "(% (% (% " ^ String.filter arabic ~f:(fun c -> c <> '?') ^ ")))" in
  let t = list_type @> list_type @> list_type @> TCon("list",[list_type]) in
  Printf.printf "%f vs %f\n" (map_likelihood g t cl) (indexed_likelihood (log 0.4, log 0.09, terms) t db)
;;
 *)
(* 
let () = 
  let tasks = 
    List.map2_exn top_past top_verbs make_word_regress_task
  in
  let learned = load_library "grammars/regress_past_features" in
  let correct = make_flat_library ((expression_of_string watch_subtrees) :: feature_terminals) in
  let frontier_size = 100000 in
  let get_solutions grammar =
    let (frontiers,dagger) = enumerate_frontiers_for_tasks grammar frontier_size tasks in
    print_string "Scoring programs... \n";
    let program_scores = score_programs dagger frontiers tasks in
    let task_solutions = List.zip_exn tasks program_scores |> List.map ~f:(fun (t,solutions) ->
        (t, List.map solutions (fun (i,s) -> 
             (i,s+. (get_some @@ likelihood_option grammar t.task_type (extract_expression dagger i)))))) in
    print_posterior_surrogate 1.0 dagger grammar task_solutions
  in
  Printf.printf "Learned:\n";
  get_solutions learned;
  Printf.printf "Correct:\n";
  get_solutions correct
;;
 *)

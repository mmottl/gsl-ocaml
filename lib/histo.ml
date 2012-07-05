(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2005 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Histograms *)

(** The histogram type *)
type t = {
    n     : int ;
    range : float array ;
    bin   : float array ;
  }

let check h =
  h.n > 0 && Array.length h.range = succ h.n && Array.length h.bin = h.n

(** {3 Allocating histograms} *)

let make n = 
  { n = n ; range = Array.create (succ n) 0. ; bin = Array.create n 0. ; }

let copy h =
  { n = h.n ;
    range = Array.copy h.range ;
    bin = Array.copy h.bin ;
  }

external set_ranges : t -> float array -> unit 
    = "ml_gsl_histogram_set_ranges"

external set_ranges_uniform : t -> xmin:float -> xmax:float -> unit 
    = "ml_gsl_histogram_set_ranges_uniform"

(** {3 Updating and accessing histogram elements} *)

external accumulate : t -> ?w:float -> float -> unit 
    = "ml_gsl_histogram_accumulate"

let get h i = 
  h.bin.(i)

let get_range h i =
  (h.range.(i), h.range.(succ i))

let h_max h = 
  h.range.(h.n)

let h_min h = 
  h.range.(0)

let bins h = 
  h.n

let reset h =
  Array.fill h.bin 0 h.n 0.

(** {3 Searching histogram ranges} *)

external find : t -> float -> int
    = "ml_gsl_histogram_find"

(** {3 Histograms statistics } *)

external max_val : t -> float
    = "ml_gsl_histogram_max_val"
external max_bin : t -> int
    = "ml_gsl_histogram_max_bin"
external min_val : t -> float
    = "ml_gsl_histogram_min_val"
external min_bin : t -> int
    = "ml_gsl_histogram_min_bin"
external mean : t -> float
    = "ml_gsl_histogram_mean"
external sigma : t -> float
    = "ml_gsl_histogram_sigma"
external sum : t -> float
    = "ml_gsl_histogram_sum"

(** {3 Histogram operations} *)

external equal_bins_p : t -> t -> bool
    = "ml_gsl_histogram_equal_bins_p"
external add : t -> t -> unit
    = "ml_gsl_histogram_add"
external sub : t -> t -> unit
    = "ml_gsl_histogram_sub"
external mul : t -> t -> unit
    = "ml_gsl_histogram_mul"
external div : t -> t -> unit
    = "ml_gsl_histogram_div"
external scale : t -> float -> unit
    = "ml_gsl_histogram_scale"
external shift : t -> float -> unit
    = "ml_gsl_histogram_shift"

(** {3 Resampling} *)

type histo_pdf = {
    pdf_n     : int ;
    pdf_range : float array ;
    pdf_sum   : float array ;
  }

external _init : histo_pdf -> t -> unit
    = "ml_gsl_histogram_pdf_init"

let init h = 
  let p = { pdf_n = h.n ;
	    pdf_range = Array.copy h.range ;
	    pdf_sum   = Array.copy h.bin ; } in
  _init p h ;
  p

external sample : histo_pdf -> float -> float
    = "ml_gsl_histogram_pdf_sample"

    

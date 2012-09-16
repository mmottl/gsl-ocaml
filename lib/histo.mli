(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)

(** Histograms *)

(** The histogram type *)
type t = private { 
    n     : int;  (** number of histogram bins *)
    range : float array; (** ranges of the bins ; n+1 elements *)
    bin   : float array; (** counts for each bin ; n elements *)
} 

val check : t -> bool

(** {3 Allocating histograms} *)

val make : int -> t
val copy : t -> t
external set_ranges : t -> float array -> unit
  = "ml_gsl_histogram_set_ranges"
external set_ranges_uniform : t -> xmin:float -> xmax:float -> unit
  = "ml_gsl_histogram_set_ranges_uniform"

(** {3 Updating and accessing histogram elements} *)

external accumulate : t -> ?w:float -> float -> unit
  = "ml_gsl_histogram_accumulate"
val get : t -> int -> float
val get_range : t -> int -> float * float
val h_max : t -> float
val h_min : t -> float
val bins  : t -> int
val reset : t -> unit

(** {3 Searching histogram ranges} *)

external find : t -> float -> int = "ml_gsl_histogram_find"

(** {3 Histograms statistics } *)

external max_val : t -> float = "ml_gsl_histogram_max_val"
external max_bin : t -> int = "ml_gsl_histogram_max_bin"
external min_val : t -> float = "ml_gsl_histogram_min_val"
external min_bin : t -> int = "ml_gsl_histogram_min_bin"
external mean  : t -> float = "ml_gsl_histogram_mean"
external sigma : t -> float = "ml_gsl_histogram_sigma"
external sum   : t -> float = "ml_gsl_histogram_sum"

(** {3 Histogram operations} *)

external equal_bins_p : t -> t -> bool = "ml_gsl_histogram_equal_bins_p"
external add : t -> t -> unit = "ml_gsl_histogram_add"
external sub : t -> t -> unit = "ml_gsl_histogram_sub"
external mul : t -> t -> unit = "ml_gsl_histogram_mul"
external div : t -> t -> unit = "ml_gsl_histogram_div"
external scale : t -> float -> unit = "ml_gsl_histogram_scale"
external shift : t -> float -> unit = "ml_gsl_histogram_shift"

(** {3 Resampling} *)

type histo_pdf = private {
  pdf_n : int;
  pdf_range : float array;
  pdf_sum : float array;
} 
val init : t -> histo_pdf
external sample : histo_pdf -> float -> float = "ml_gsl_histogram_pdf_sample"

Section SimpleChineseRemainder.

Require Import Znumtheory.
Require Import Zdiv.
Require Import ZArith.
Import Z.

Open Scope Z_scope.

Definition modulo (a b n : Z) : Prop := (n | (a - b)).
Notation "a == b [ n ]" := (modulo a b n) (at level 50). 

Lemma modulo_refl : forall a n : Z, (a == a [n]).
Proof.
    intros a n.
    red.
    rewrite sub_diag.
    apply divide_0_r.
Qed.

Lemma modulo_symm : forall a b n : Z, (a == b [n]) -> (b == a [n]).
Proof.
    intros a b n Hab.
    red in Hab |- *.
    apply Zdivide_opp_r_rev.
    cut (- (b - a) = a - b). 
        intros H.
        rewrite H.
        exact Hab.

        unfold sub.
        rewrite opp_add_distr.
        rewrite opp_involutive.
        rewrite add_comm.
    auto with *.
Qed.

Lemma modulo_tran : forall a b c n : Z, (a == b [n]) -> (b == c [n]) -> (a == c [n]).
Proof.
    intros a b c n Hab Hbc.
    red in Hab, Hbc |- *.
    cut (a - c = a - b + (b - c)).
        intros H.
        rewrite H.
        apply divide_add_r.
            trivial.                (* exact Hab *)
            trivial.                (* exact Hbc *)
    auto with *.
Qed.

Lemma modulo_plus_comm : forall a b n : Z, (a + b == b + a [n]).
Proof.
    intros a b c.
    red.
    rewrite add_comm.
    rewrite sub_diag.
    auto with *.
Qed.

Lemma modulo_plus_assoc : forall a b c n : Z, (a + b + c == a + (b + c) [n]).
Proof.
    intros a b c n.
    red.
    rewrite add_assoc.
    rewrite sub_diag.
    auto with *.
Qed.

Lemma modulo_plus_subst : forall a b c n : Z, (a == b [n]) -> (a + c == b + c [n]).
Proof.
    intros a b c n Hab.
    red in Hab |- *.
    cut (a + c - (b + c) = a - b).
        intros H.
        rewrite H.
        trivial.                    (* exact Hab *)
    auto with *.
Qed.

(* more lemmae and theorems here *)

Lemma modulo_plus_iff : forall a b c m n : Z, (a * m == c [n]) <-> (a * m + b * n == c [n]).
Proof.
    intros a b c m n .
    unfold iff.
    refine (conj _ _).
        (* case : (a * m == c [n]) -> (a * m + b * n == c [n]) *)
        intros H; red in H |- *.
        rewrite add_sub_swap.
        apply divide_add_r.
        exact H.
        apply divide_factor_r.

        (* case : (a * m + b * n == c [n]) -> (a * m == c [n]) *)
        intros H.
        apply divide_add_cancel_r with (m := b * n).
        apply divide_factor_r.
        rewrite add_sub_assoc.
        rewrite add_comm.
        exact H.
Qed.

Hypothesis m n : Z.
Hypothesis co_prime : rel_prime m n.

Theorem modulo_inv : forall m n : Z, rel_prime m n -> exists x : Z, (m * x == 1 [n]).
Proof.
    intros m0 n0 Hrel_prime.
    elim (Zis_gcd_bezout m0 n0 1).  
        intros u v Heq.
        exists u.
        rewrite mul_comm.
        apply modulo_plus_iff with (b := v).
        rewrite Heq.
        red.
        rewrite sub_diag.
        apply divide_0_r.
        trivial.
Qed.

Theorem SimpleChineseRemainder : forall a b : Z, exists x : Z, (x == a [m]) /\ (x == b [n]).
Proof.
    intros a b.
    destruct (rel_prime_bezout _ _ co_prime) as [u v Heq].
    exists (a * v * n + b * u * m).
    split.
        (* case : (a * v * n + b * u * m) == a [m] *)
        apply add_move_l in Heq.
        rewrite <- mul_assoc, Heq, mul_sub_distr_l, mul_assoc,
                <- add_sub_swap, <- add_sub_assoc, <- mul_sub_distr_r.
        apply modulo_plus_iff.
        red.
        rewrite mul_1_r.
        rewrite sub_diag.
        apply divide_0_r.

        (* case : (a * v * n + b * u * m) == b [n] *)
        rewrite add_comm.
        apply add_move_r in Heq.
        rewrite <- mul_assoc, Heq, mul_sub_distr_l, mul_assoc,
                <- add_sub_swap, <- add_sub_assoc, <- mul_sub_distr_r.
        apply modulo_plus_iff.
        red.
        rewrite mul_1_r.
        rewrite sub_diag.
        apply divide_0_r.
Qed.
End SimpleChineseRemainder.
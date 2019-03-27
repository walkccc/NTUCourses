(* https://coq.inria.fr/tutorial-nahas *)
Section coqTutorial.
Theorem my_first_proof__again__again : (forall A : Prop, A -> A).
Proof.
  intros A.
  intros proof_of_A.
  exact proof_of_A.
Qed.

Theorem forward_small : (forall A B : Prop, A -> (A->B) -> B).
Proof.
  intros A.
  intros B.
  intros proof_of_A.
  intros A_implies_B.
  pose (proof_of_B := A_implies_B proof_of_A).
  exact proof_of_B.
Qed.

Theorem backward_small : (forall A B : Prop, A -> (A->B)->B).
Proof.
 intros A B.
 intros proof_of_A A_implies_B.
 refine (A_implies_B _).
   exact proof_of_A.
Qed.

Theorem backward_large : (forall A B C : Prop,
A -> (A->B) -> (B->C) -> C).
Proof.
  intros A B C.
  intros proof_of_A A_implies_B B_implies_C.
  refine (B_implies_C _).
    refine (A_implies_B _).
    exact proof_of_A.
Qed.

Theorem backward_huge : (forall A B C : Prop, 
A -> (A->B) -> (A->B->C) -> C).
Proof.
  intros A B C.
  intros proof_of_A A_implies_B A_imp_B_imp_C.
  refine (A_imp_B_imp_C _ _).
    exact proof_of_A.

    refine (A_implies_B _).
      exact proof_of_A.
Qed.

Theorem forward_huge : (forall A B C : Prop, A -> (A->B) -> (A->B->C) -> C).
Proof.
  intros A B C.
  intros proof_of_A A_implies_B A_imp_B_imp_C.

  pose (proof_of_B := A_implies_B proof_of_A).
  pose (proof_of_C := A_imp_B_imp_C proof_of_A proof_of_B).
  exact proof_of_C.
Show Proof.
Qed.

Theorem Ture_can_be_proven : True.
  exact I.
Qed.

Theorem False_cannot_be_proven : ~False.
Proof.
  unfold not.
  intros proof_of_False.
  exact proof_of_False.
Qed.

Theorem False_cannot_be_proven__again : ~False.
Proof.
  intros proof_of_False.
  case proof_of_False.
Qed.

Theorem thm_true_imp_true : True -> True.
Proof.
  intros proof_of_True.
  exact I.
Qed.

Theorem thm_false_imp_true : False -> True.
Proof.
  intros proof_of_False.
  exact I.
Qed.

Theorem thm_false_imp_false : False -> False.
Proof.
  intros proof_of_False.
  case proof_of_False.
Qed.

Theorem thm_true_imp_false : ~(True -> False).
Proof.
  intros T_implies_F.
  refine (T_implies_F _).
    exact I.
Qed.

Theorem absurd2 : forall A C : Prop, A -> ~ A -> C.
Proof.
  intros A C.
  intros proof_of_A proof_that_A_cannot_be_proven.
  unfold not in proof_that_A_cannot_be_proven.
  pose (proof_of_False := proof_that_A_cannot_be_proven proof_of_A).
  case proof_of_False.
Qed.

Require Import Bool.

Theorem true_is_Ture: Is_true true.
Proof.
  simpl.
  exact I.
Qed.

Theorem not_eqb_true_false: ~(Is_true (eqb true false)).
Proof.
  simpl.
  exact False_cannot_be_proven.
Qed.

Theorem eqb_a_a : (forall a : bool, Is_true (eqb a a)).
Proof.
  intros a.
  case a.
    simpl.
    exact I.
    simpl.
    exact I.
Qed.

Theorem thm_eqb_a_t: (forall a : bool,
(Is_true (eqb a true)) -> (Is_true a)).
Proof.
  intros a.
  case a.
    simpl.
    intros proof_of_True.
    exact I.
    simpl.
    intros proof_of_False.
    case proof_of_False.
Qed.

Theorem left_or : (forall A B : Prop, A -> A \/ B).
Proof.
  intros A B.
  intros proof_of_A.
  pose (proof_of_A_or_B := or_introl proof_of_A : A \/ B).
  exact proof_of_A_or_B.
Qed.

Theorem right_or : (forall A B : Prop, B -> A \/ B).
Proof.
  intros A B.
  intros proof_of_B.
  refine (or_intror _).
    exact proof_of_B.
Qed.

Theorem or_commutes : (forall A B, A \/ B -> B \/ A).
Proof.
  intros A B.
  intros A_or_B.
  case A_or_B.
    intros proof_of_A.
    refine (or_intror _).
      exact proof_of_A.
    intros proof_of_B.
    refine (or_introl _).
      exact proof_of_B.
Qed.

Theorem both_and : (forall A B : Prop, A -> B -> A /\ B).
Proof.
  intros A B.
  intros proof_of_A proof_of_B.
  refine (conj _ _).
    exact proof_of_A.

    exact proof_of_B.
Qed.

Theorem and_commutes : (forall A B, A /\ B -> B /\ A).
Proof.
  intros A B.
  intros A_and_B.
  case A_and_B.
    intros proof_of_A proof_of_B.
    refine (conj _ _).
      exact proof_of_B.

      exact proof_of_A.
Qed.

Theorem and_commutes__again : (forall A B, A /\ B -> B /\ A).
Proof.
  intros A B.
  intros A_and_B.
  destruct A_and_B as [ proof_of_A proof_of_B].
  refine (conj _ _).
    exact proof_of_B.

    exact proof_of_A.
Qed.

Theorem orb_is_or : (forall a b, Is_true (orb a b) <-> Is_true a \/ Is_true b).
Proof.
  intros a b.
  unfold iff.
  refine (conj _ _).
    intros H.
    case a, b.
      simpl.
      refine (or_introl _).
        exact I.
      simpl.
      exact (or_introl I).
      simpl.
      exact (or_intror I).
      simpl in H.
      case H.

    intros H.
    case a, b.
      simpl.
      exact I.
      simpl.
      exact I.
      simpl.
      exact I.
      simpl.
      case H.
        intros A.
        simpl in A.
        case A.
        intros B.
        simpl in B.
        case B.
Qed.

Theorem andb_is_and : (forall a b, Is_true (andb a b) <-> Is_true a /\ Is_true b).
Proof.
  intros a b.
  unfold iff.
  refine (conj _ _).
    intros H.
    case a, b.

      simpl.
      exact (conj I I).

      simpl in H.
      case H.

      simpl in H.
      case H.

      simpl in H.
      case H.

    intros H.
    case a,b.
      simpl.
      exact I.

      simpl in H.
      destruct H as [ A B].
      case B.

      simpl in H.
      destruct H as [ A B].
      case A.

      simpl in H.
      destruct H as [ A B].
      case A.
Qed.

Definition basic_predicate := (fun a => Is_true (andb a true)).

Theorem thm_exists_basics : (ex basic_predicate).
Proof.
  pose (witness := true).
  refine (ex_intro basic_predicate witness _).
    simpl.
    exact I.
Qed.

Theorem plus_sym: (forall n m, n + m = m + n).
Proof.
  intros n m.
  elim n.
    elim m.
      exact (eq_refl (O + O)).
      intros m'.
      intros inductive_hyp_m.
      simpl.
      rewrite <- inductive_hyp_m.
      simpl.
      exact (eq_refl (S m')).
    intros n'.
    intros inductive_hyp_n.
    simpl.
    rewrite inductive_hyp_n.
    elim m.
      simpl.
      exact (eq_refl (S n')).

      intros m'.
      intros inductive_hyp_m.
      simpl.
      rewrite inductive_hyp_m.
      simpl.
      exact (eq_refl (S (m' + S n'))).
Qed.



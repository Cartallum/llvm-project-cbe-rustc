; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64 -relocation-model=static < %s | \
; RUN:   FileCheck --check-prefixes=COMMON,STATIC %s
; RUN: llc -mtriple=x86_64 -relocation-model=pic < %s | \
; RUN:   FileCheck --check-prefixes=COMMON,CHECK %s

;; Test that we use the local alias for dso_local functions in inline assembly.

@gv0 = dso_local global i32 0
@gv1 = dso_preemptable global i32 1

define i64 @test_var() nounwind {
; STATIC-LABEL: test_var:
; STATIC:       # %bb.0: # %entry
; STATIC-NEXT:    movq gv1@GOTPCREL(%rip), %rax
; STATIC-NEXT:    #APP
; STATIC-NEXT:    movq gv0(%rip), %rax
; STATIC-NEXT:    movq (%rax), %rax
; STATIC-NEXT:    #NO_APP
; STATIC-NEXT:    retq
;
; CHECK-LABEL: test_var:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq gv1@GOTPCREL(%rip), %rax
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movq .Lgv0$local(%rip), %rax
; CHECK-NEXT:    movq (%rax), %rax
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    retq
entry:
  %0 = tail call i64 asm "movq $1, $0\0Amovq $2, $0", "=r,*m,*m"(i32* elementtype(i32) @gv0, i32* elementtype(i32) @gv1)
  ret i64 %0
}

define dso_local void @fun0() nounwind {
; COMMON-LABEL: fun0:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    retq
entry:
  ret void
}

define dso_preemptable void @fun1() nounwind {
; COMMON-LABEL: fun1:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    retq
entry:
  ret void
}

define i64 @test_fun() nounwind {
; STATIC-LABEL: test_fun:
; STATIC:       # %bb.0: # %entry
; STATIC-NEXT:    movq fun1@GOTPCREL(%rip), %rax
; STATIC-NEXT:    #APP
; STATIC-NEXT:    movq fun0(%rip), %rax
; STATIC-NEXT:    movq (%rax), %rax
; STATIC-NEXT:    #NO_APP
; STATIC-NEXT:    retq
;
; CHECK-LABEL: test_fun:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq fun1@GOTPCREL(%rip), %rax
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movq .Lfun0$local(%rip), %rax
; CHECK-NEXT:    movq (%rax), %rax
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    retq
entry:
  %0 = tail call i64 asm "movq $1, $0\0Amovq $2, $0", "=r,*m,*m"(void ()* elementtype(void ()) nonnull @fun0, void ()* elementtype(void ()) nonnull @fun1)
  ret i64 %0
}
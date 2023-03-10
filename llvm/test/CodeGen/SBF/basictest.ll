; RUN: llc < %s -march=sbf | FileCheck %s

define i32 @test0(i32 %X) {
  %tmp.1 = add i32 %X, 1
  ret i32 %tmp.1
; CHECK-LABEL: test0:
; CHECK: add64 r0, 1
}

; CHECK-LABEL: store_imm:
; CHECK: stxw [r1 + 0], r{{[03]}}
; CHECK: stxw [r2 + 4], r{{[03]}}
define i32 @store_imm(i32* %a, i32* %b) {
entry:
  store i32 0, i32* %a, align 4
  %0 = getelementptr inbounds i32, i32* %b, i32 1
  store i32 0, i32* %0, align 4
  ret i32 0
}

@G = external global i8
define zeroext i8 @loadG() {
  %tmp = load i8, i8* @G
  ret i8 %tmp
; CHECK-LABEL: loadG:
; CHECK: lddw r1, G
; CHECK: ldxb r0, [r1 + 0]
}

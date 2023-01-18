; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -licm < %s | FileCheck %s

%class.LiveThread = type { i64, %class.LiveThread* }

@globallive = external dso_local global i64, align 8

; The store should not be sunk (via scalar promotion) past the cmpxchg.

define void @test(%class.LiveThread* %live_thread) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[NEXT_UNPROCESSED_:%.*]] = getelementptr inbounds [[CLASS_LIVETHREAD:%.*]], %class.LiveThread* [[LIVE_THREAD:%.*]], i64 0, i32 1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    store %class.LiveThread* undef, %class.LiveThread** [[NEXT_UNPROCESSED_]], align 8
; CHECK-NEXT:    [[XCHG:%.*]] = cmpxchg weak i64* @globallive, i64 undef, i64 undef release monotonic
; CHECK-NEXT:    [[DONE:%.*]] = extractvalue { i64, i1 } [[XCHG]], 1
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  %next_unprocessed_ = getelementptr inbounds %class.LiveThread, %class.LiveThread* %live_thread, i64 0, i32 1
  br label %loop

loop:
  store %class.LiveThread* undef, %class.LiveThread** %next_unprocessed_, align 8
  %xchg = cmpxchg weak i64* @globallive, i64 undef, i64 undef release monotonic
  %done = extractvalue { i64, i1 } %xchg, 1
  br i1 %done, label %exit, label %loop

exit:
  ret void
}

# Design plan — Pipe cross clamp, fixed angle

Brief version 0.1 approved on 2026-09-26 by the MSF 3D Printing Advisor ("proceed"). Owner as requester: the plan is written alongside the model (§2.1). Stages 3–6 run in one pass.

| # | Sub-task | Output (file / render / check result) | Load | Gate — what the user does |
|---|---|---|---|---|
| 1 | Shared values, helpers, coupon, checker | common.scad, helpers.scad (skill copies), pipe_cross_clamp_coupon.scad + STL, tools/ | Low | — |
| 2 | Model: body — convex plan outline, two V-seats (bottom pointed roof, top flat floor), web | pipe_cross_clamp.scad, preview render | Medium | accepts the preview |
| 3 | Model: closures — through-bolt positions for any θ, caps (hump + two lobes), zip-tie U-channels at two heights; seat gauge | updated .scad, ghost previews, pipe_cross_clamp_context.scad | Medium | confirms fit types |
| 4 | Verification (§10) and render set (T14) | sweep report, check_stl results, img/ | Low | — |
| 5 | Delivery package (§11) | zip, README, EXPORT_LOG, STATUS.md | Low | prints coupon + gauge, then part |
| 6 | Coupon and first-article feedback (§2.2), revision | confirmed-values table, v1.1 | Low | reports fit, photos |

Rules: never add work to a High stage; building ahead of a physical result is allowed, releasing is not. Version 1.0 ships as "not confirmed" until the coupon, gauge and first article are reported.

#map = affine_map<(d0, d1, d2) -> (d0, d1, d2)>

func.func @forward() {
  %cst = util.unfoldable_constant dense<[
    [0, 1, 2, 3, 4, 5, 6, 7], [8, 9, 10, 11, 12, 13, 14, 15],
    [0, 1, 2, 3, 4, 5, 6, 7], [8, 9, 10, 11, 12, 13, 14, 15],
    [0, 1, 2, 3, 4, 5, 6, 7], [8, 9, 10, 11, 12, 13, 14, 15],
    [0, 1, 2, 3, 4, 5, 6, 7], [8, 9, 10, 11, 12, 13, 14, 15]
  ]> : tensor<8x8xi4>
  %expanded_4 = tensor.expand_shape %cst [[0], [1, 2]] : tensor<8x8xi4> into tensor<8x4x2xi4>
  %0 = tensor.empty() : tensor<8x4x2xf32>
  %5 = linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel", "parallel", "parallel"]} ins(%expanded_4 : tensor<8x4x2xi4>) outs(%0 : tensor<8x4x2xf32>) {
  ^bb0(%in: i4, %out: f32):
    %6 = arith.extui %in : i4 to i32
    %7 = arith.uitofp %6 : i32 to f32
    linalg.yield %7 : f32
  } -> tensor<8x4x2xf32>
  check.expect_almost_eq_const(%5, dense<[
    [[0., 1.], [2., 3.], [4., 5.], [6., 7.]], [[8., 9.], [10., 11.], [12., 13.], [14., 15.]],
    [[0., 1.], [2., 3.], [4., 5.], [6., 7.]], [[8., 9.], [10., 11.], [12., 13.], [14., 15.]],
    [[0., 1.], [2., 3.], [4., 5.], [6., 7.]], [[8., 9.], [10., 11.], [12., 13.], [14., 15.]],
    [[0., 1.], [2., 3.], [4., 5.], [6., 7.]], [[8., 9.], [10., 11.], [12., 13.], [14., 15.]]
  ]> : tensor<8x4x2xf32>) : tensor<8x4x2xf32>
  return
}

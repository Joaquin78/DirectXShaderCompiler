// Run: %dxc -T ps_6_0 -E main

struct SBuffer {
    float4   f1;
    float2x3 f2[3];
};

  StructuredBuffer<SBuffer> mySBuffer1;
RWStructuredBuffer<SBuffer> mySBuffer2;

float4 main(int index: A) : SV_Target {
    // b1 and b2's type does not need layout decorations. So it's a different
    // SBuffer definition.
// XXXXX-NOT:  OpMemberDecorate %SBuffer_0 0 Offset 0
// XXXXX:      %_ptr_Function_SBuffer_0 = OpTypePointer Function %SBuffer_0

// XXXXX:      %b1 = OpVariable %_ptr_Function_SBuffer_0 Function
// XXXXX-NEXT: %b2 = OpVariable %_ptr_Function_SBuffer_0 Function

// TODO: wrong codegen right now: missing load the value from sb1 & sb2
// TODO: need to make sure we have %SBuffer (not %SBuffer_0) as the loaded type
// XXXXX:      [[index:%\d+]] = OpLoad %int %index
// XXXXX:      [[sb1:%\d+]] = OpAccessChain %_ptr_Uniform_SBuffer %mySBuffer1 %int_0 [[index]]
// XXXXX:      {{%\d+}} = OpLoad %SBuffer [[sb1]]
// XXXXX:      [[sb2:%\d+]] = OpAccessChain %_ptr_Uniform_SBuffer %mySBuffer2 %int_0 %int_0
// XXXXX:      {{%\d+}} = OpLoad %SBuffer [[sb2]]
    //SBuffer b1 = mySBuffer1.Load(index);
    //SBuffer b2;
    //b2 = mySBuffer2.Load(0);

// CHECK:      [[f1:%\d+]] = OpAccessChain %_ptr_Uniform_v4float %mySBuffer1 %int_0 %int_5 %int_0
// CHECK-NEXT: [[x:%\d+]] = OpAccessChain %_ptr_Uniform_float [[f1]] %int_0
// CHECK-NEXT: {{%\d+}} = OpLoad %float [[x]]

// CHECK:      [[index:%\d+]] = OpLoad %int %index
// CHECK-NEXT: [[f012:%\d+]] = OpAccessChain %_ptr_Uniform_float %mySBuffer2 %int_0 [[index]] %int_1 %int_0 %uint_1 %uint_2
// CHECK-NEXT: {{%\d+}} = OpLoad %float [[f012]]
    return mySBuffer1.Load(5).f1.x + mySBuffer2.Load(index).f2[0][1][2];
}
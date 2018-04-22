; ModuleID = 'hotspot.preopt.ll'
source_filename = "hotspot.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.timeval = type { i64, i64 }
%struct.timezone = type { i32, i32 }

@stderr = external local_unnamed_addr global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [11 x i8] c"error: %s\0A\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"%d\09%g\0A\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.5 = private unnamed_addr constant [37 x i8] c"file could not be opened for reading\00", align 1
@.str.6 = private unnamed_addr constant [25 x i8] c"not enough lines in file\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"%f\00", align 1
@.str.8 = private unnamed_addr constant [20 x i8] c"invalid file format\00", align 1
@.str.9 = private unnamed_addr constant [87 x i8] c"Usage: %s <grid_rows> <grid_cols> <sim_time> <no. of threads><temp_file> <power_file>\0A\00", align 1
@.str.10 = private unnamed_addr constant [63 x i8] c"\09<grid_rows>  - number of rows in the grid (positive integer)\0A\00", align 1
@.str.11 = private unnamed_addr constant [66 x i8] c"\09<grid_cols>  - number of columns in the grid (positive integer)\0A\00", align 1
@.str.12 = private unnamed_addr constant [38 x i8] c"\09<sim_time>   - number of iterations\0A\00", align 1
@.str.13 = private unnamed_addr constant [41 x i8] c"\09<no. of threads>   - number of threads\0A\00", align 1
@.str.14 = private unnamed_addr constant [89 x i8] c"\09<temp_file>  - name of the file containing the initial temperature values of each cell\0A\00", align 1
@.str.15 = private unnamed_addr constant [86 x i8] c"\09<power_file> - name of the file containing the dissipated power values of each cell\0A\00", align 1
@.str.16 = private unnamed_addr constant [42 x i8] c"\09<output_file> - name of the output file\0A\00", align 1
@.str.17 = private unnamed_addr constant [26 x i8] c"unable to allocate memory\00", align 1
@.str.20 = private unnamed_addr constant [26 x i8] c"Total time: %.3f seconds\0A\00", align 1
@str = private unnamed_addr constant [24 x i8] c"The file was not opened\00"
@str.21 = private unnamed_addr constant [42 x i8] c"Start computing the transient temperature\00"
@str.22 = private unnamed_addr constant [18 x i8] c"Ending simulation\00"

; Function Attrs: nounwind uwtable
define i64 @_Z8get_timev() local_unnamed_addr #0 {
entry:
  %tv = alloca %struct.timeval, align 8
  br label %entry.split

entry.split:                                      ; preds = %entry
  %0 = bitcast %struct.timeval* %tv to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %0) #6
  %call = call i32 @gettimeofday(%struct.timeval* nonnull %tv, %struct.timezone* null) #6
  %tv_sec = getelementptr inbounds %struct.timeval, %struct.timeval* %tv, i64 0, i32 0
  %1 = load i64, i64* %tv_sec, align 8, !tbaa !2
  %mul = mul nsw i64 %1, 1000000
  %tv_usec = getelementptr inbounds %struct.timeval, %struct.timeval* %tv, i64 0, i32 1
  %2 = load i64, i64* %tv_usec, align 8, !tbaa !7
  %add = add nsw i64 %mul, %2
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %0) #6
  ret i64 %add
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind
declare i32 @gettimeofday(%struct.timeval* nocapture, %struct.timezone* nocapture) local_unnamed_addr #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define void @_Z16single_iterationPfS_S_iifffff(float* nocapture %result, float* readonly %temp, float* nocapture readonly %power, i32 %row, i32 %col, float %Cap_1, float %Rx_1, float %Ry_1, float %Rz_1, float %step) local_unnamed_addr #0 {
entry:
  br label %entry.split

entry.split:                                      ; preds = %entry
  %syncreg = tail call token @llvm.syncregion.start()
  %mul = mul nsw i32 %col, %row
  %div = sdiv i32 %mul, 256
  %div1 = sdiv i32 %col, 16
  %div2 = sdiv i32 %row, 16
  %cmp780 = icmp sgt i32 %mul, 255
  br i1 %cmp780, label %pfor.detach.lr.ph, label %pfor.cond.cleanup

pfor.detach.lr.ph:                                ; preds = %entry.split
  %arrayidx38 = getelementptr inbounds float, float* %temp, i64 1
  %idxprom = sext i32 %col to i64
  %arrayidx43 = getelementptr inbounds float, float* %temp, i64 %idxprom
  %sub55 = add nsw i32 %col, -1
  %sub83 = add nsw i32 %row, -1
  %conv = fpext float %Cap_1 to double
  %conv180 = fpext float %Rx_1 to double
  %conv229 = fpext float %Ry_1 to double
  %broadcast.splatinsert870 = insertelement <4 x float> undef, float %Ry_1, i32 0
  %broadcast.splat871 = shufflevector <4 x float> %broadcast.splatinsert870, <4 x float> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert874 = insertelement <4 x float> undef, float %Rx_1, i32 0
  %broadcast.splat875 = shufflevector <4 x float> %broadcast.splatinsert874, <4 x float> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert876 = insertelement <4 x float> undef, float %Rz_1, i32 0
  %broadcast.splat877 = shufflevector <4 x float> %broadcast.splatinsert876, <4 x float> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert878 = insertelement <4 x float> undef, float %Cap_1, i32 0
  %broadcast.splat879 = shufflevector <4 x float> %broadcast.splatinsert878, <4 x float> undef, <4 x i32> zeroinitializer
  br label %pfor.detach

pfor.cond.cleanup.loopexit:                       ; preds = %pfor.inc
  br label %pfor.cond.cleanup

pfor.cond.cleanup:                                ; preds = %pfor.cond.cleanup.loopexit, %entry.split
  sync within %syncreg, label %pfor.end.continue

pfor.end.continue:                                ; preds = %pfor.cond.cleanup
  ret void

pfor.detach:                                      ; preds = %pfor.inc, %pfor.detach.lr.ph
  %__begin.0781 = phi i32 [ 0, %pfor.detach.lr.ph ], [ %inc463, %pfor.inc ]
  detach within %syncreg, label %pfor.body, label %pfor.inc

pfor.body:                                        ; preds = %pfor.detach
  %div7 = sdiv i32 %__begin.0781, %div2
  %mul8 = shl nsw i32 %div7, 4
  %rem = srem i32 %__begin.0781, %div1
  %mul9 = shl nsw i32 %rem, 4
  %add10 = add nsw i32 %mul8, 16
  %add13 = add nsw i32 %mul9, 16
  %cmp20 = icmp ne i32 %div7, 0
  %cmp21 = icmp ne i32 %rem, 0
  %or.cond.not = and i1 %cmp20, %cmp21
  %cmp23 = icmp slt i32 %add10, %row
  %or.cond765 = and i1 %or.cond.not, %cmp23
  %cmp25 = icmp slt i32 %add13, %col
  %or.cond766 = and i1 %or.cond765, %cmp25
  %0 = sext i32 %mul9 to i64
  %1 = sext i32 %add13 to i64
  %2 = sext i32 %mul8 to i64
  %3 = sext i32 %add10 to i64
  br i1 %or.cond766, label %if.end376, label %for.body.preheader

for.body.preheader:                               ; preds = %pfor.body
  br label %for.body

for.body:                                         ; preds = %for.cond.cleanup33, %for.body.preheader
  %indvars.iv799 = phi i64 [ %indvars.iv.next800, %for.cond.cleanup33 ], [ %2, %for.body.preheader ]
  %delta.0.delta.0.774.lcssa777 = phi float [ %delta.0.delta.0.774.lcssa, %for.cond.cleanup33 ], [ undef, %for.body.preheader ]
  %4 = trunc i64 %indvars.iv799 to i32
  %cmp35 = icmp eq i32 %4, 0
  %5 = mul nsw i64 %indvars.iv799, %idxprom
  %cmp84 = icmp eq i32 %sub83, %4
  %6 = add nsw i64 %indvars.iv799, -1
  %7 = mul nsw i64 %6, %idxprom
  %arrayidx133 = getelementptr inbounds float, float* %power, i64 %5
  %8 = add nsw i64 %5, 1
  %arrayidx137 = getelementptr inbounds float, float* %temp, i64 %8
  %arrayidx140 = getelementptr inbounds float, float* %temp, i64 %5
  %arrayidx147 = getelementptr inbounds float, float* %temp, i64 %7
  %indvars.iv.next800 = add nsw i64 %indvars.iv799, 1
  %9 = mul nsw i64 %indvars.iv.next800, %idxprom
  %arrayidx321 = getelementptr inbounds float, float* %temp, i64 %9
  br label %for.body34

for.cond.cleanup33:                               ; preds = %if.end363
  %delta.0.delta.0.774.lcssa = phi float [ %delta.0.delta.0.774, %if.end363 ]
  %cmp28 = icmp slt i64 %indvars.iv.next800, %3
  br i1 %cmp28, label %for.body, label %cleanup.cont462.loopexit1

for.body34:                                       ; preds = %if.end363, %for.body
  %indvars.iv = phi i64 [ %0, %for.body ], [ %indvars.iv.next, %if.end363 ]
  %delta.0.delta.0.773 = phi float [ %delta.0.delta.0.774.lcssa777, %for.body ], [ %delta.0.delta.0.774, %if.end363 ]
  %10 = trunc i64 %indvars.iv to i32
  %cmp36 = icmp eq i32 %10, 0
  %11 = or i64 %indvars.iv, %indvars.iv799
  %12 = trunc i64 %11 to i32
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %if.then37, label %if.else

if.then37:                                        ; preds = %for.body34
  %14 = load float, float* %power, align 4, !tbaa !8
  %15 = load float, float* %arrayidx38, align 4, !tbaa !8
  %16 = load float, float* %temp, align 4, !tbaa !8
  %sub40 = fsub float %15, %16
  %mul41 = fmul float %sub40, %Rx_1
  %add42 = fadd float %14, %mul41
  %17 = load float, float* %arrayidx43, align 4, !tbaa !8
  %sub45 = fsub float %17, %16
  %mul46 = fmul float %sub45, %Ry_1
  %add47 = fadd float %add42, %mul46
  %sub49 = fsub float 8.000000e+01, %16
  %mul50 = fmul float %sub49, %Rz_1
  %add51 = fadd float %mul50, %add47
  %mul52 = fmul float %add51, %Cap_1
  br label %if.end363

if.else:                                          ; preds = %for.body34
  %cmp56 = icmp eq i32 %sub55, %10
  %or.cond767 = and i1 %cmp35, %cmp56
  br i1 %or.cond767, label %if.then57, label %if.else82

if.then57:                                        ; preds = %if.else
  %arrayidx59 = getelementptr inbounds float, float* %power, i64 %indvars.iv
  %18 = load float, float* %arrayidx59, align 4, !tbaa !8
  %19 = add nsw i64 %indvars.iv, -1
  %arrayidx62 = getelementptr inbounds float, float* %temp, i64 %19
  %20 = load float, float* %arrayidx62, align 4, !tbaa !8
  %arrayidx64 = getelementptr inbounds float, float* %temp, i64 %indvars.iv
  %21 = load float, float* %arrayidx64, align 4, !tbaa !8
  %sub65 = fsub float %20, %21
  %mul66 = fmul float %sub65, %Rx_1
  %add67 = fadd float %18, %mul66
  %22 = add nsw i64 %indvars.iv, %idxprom
  %arrayidx70 = getelementptr inbounds float, float* %temp, i64 %22
  %23 = load float, float* %arrayidx70, align 4, !tbaa !8
  %sub73 = fsub float %23, %21
  %mul74 = fmul float %sub73, %Ry_1
  %add75 = fadd float %add67, %mul74
  %sub78 = fsub float 8.000000e+01, %21
  %mul79 = fmul float %sub78, %Rz_1
  %add80 = fadd float %mul79, %add75
  %mul81 = fmul float %add80, %Cap_1
  br label %if.end363

if.else82:                                        ; preds = %if.else
  %or.cond768 = and i1 %cmp84, %cmp56
  br i1 %or.cond768, label %if.then88, label %if.else125

if.then88:                                        ; preds = %if.else82
  %24 = add nsw i64 %indvars.iv, %5
  %arrayidx92 = getelementptr inbounds float, float* %power, i64 %24
  %25 = load float, float* %arrayidx92, align 4, !tbaa !8
  %26 = add nsw i64 %24, -1
  %arrayidx97 = getelementptr inbounds float, float* %temp, i64 %26
  %27 = load float, float* %arrayidx97, align 4, !tbaa !8
  %arrayidx101 = getelementptr inbounds float, float* %temp, i64 %24
  %28 = load float, float* %arrayidx101, align 4, !tbaa !8
  %sub102 = fsub float %27, %28
  %mul103 = fmul float %sub102, %Rx_1
  %add104 = fadd float %25, %mul103
  %29 = add nsw i64 %indvars.iv, %7
  %arrayidx109 = getelementptr inbounds float, float* %temp, i64 %29
  %30 = load float, float* %arrayidx109, align 4, !tbaa !8
  %sub114 = fsub float %30, %28
  %mul115 = fmul float %sub114, %Ry_1
  %add116 = fadd float %add104, %mul115
  %sub121 = fsub float 8.000000e+01, %28
  %mul122 = fmul float %sub121, %Rz_1
  %add123 = fadd float %mul122, %add116
  %mul124 = fmul float %add123, %Cap_1
  br label %if.end363

if.else125:                                       ; preds = %if.else82
  %or.cond469 = and i1 %cmp84, %cmp36
  br i1 %or.cond469, label %if.then130, label %if.else161

if.then130:                                       ; preds = %if.else125
  %31 = load float, float* %arrayidx133, align 4, !tbaa !8
  %32 = load float, float* %arrayidx137, align 4, !tbaa !8
  %33 = load float, float* %arrayidx140, align 4, !tbaa !8
  %sub141 = fsub float %32, %33
  %mul142 = fmul float %sub141, %Rx_1
  %add143 = fadd float %31, %mul142
  %34 = load float, float* %arrayidx147, align 4, !tbaa !8
  %sub151 = fsub float %34, %33
  %mul152 = fmul float %sub151, %Ry_1
  %add153 = fadd float %add143, %mul152
  %sub157 = fsub float 8.000000e+01, %33
  %mul158 = fmul float %sub157, %Rz_1
  %add159 = fadd float %mul158, %add153
  %mul160 = fmul float %add159, %Cap_1
  br label %if.end363

if.else161:                                       ; preds = %if.else125
  br i1 %cmp35, label %if.then163, label %if.else200

if.then163:                                       ; preds = %if.else161
  %arrayidx165 = getelementptr inbounds float, float* %power, i64 %indvars.iv
  %35 = load float, float* %arrayidx165, align 4, !tbaa !8
  %conv166 = fpext float %35 to double
  %36 = add nsw i64 %indvars.iv, 1
  %arrayidx169 = getelementptr inbounds float, float* %temp, i64 %36
  %37 = load float, float* %arrayidx169, align 4, !tbaa !8
  %38 = add nsw i64 %indvars.iv, -1
  %arrayidx172 = getelementptr inbounds float, float* %temp, i64 %38
  %39 = load float, float* %arrayidx172, align 4, !tbaa !8
  %add173 = fadd float %37, %39
  %conv174 = fpext float %add173 to double
  %arrayidx176 = getelementptr inbounds float, float* %temp, i64 %indvars.iv
  %40 = load float, float* %arrayidx176, align 4, !tbaa !8
  %conv177 = fpext float %40 to double
  %mul178 = fmul double %conv177, 2.000000e+00
  %sub179 = fsub double %conv174, %mul178
  %mul181 = fmul double %sub179, %conv180
  %add182 = fadd double %mul181, %conv166
  %41 = add nsw i64 %indvars.iv, %idxprom
  %arrayidx185 = getelementptr inbounds float, float* %temp, i64 %41
  %42 = load float, float* %arrayidx185, align 4, !tbaa !8
  %sub188 = fsub float %42, %40
  %mul189 = fmul float %sub188, %Ry_1
  %conv190 = fpext float %mul189 to double
  %add191 = fadd double %add182, %conv190
  %sub194 = fsub float 8.000000e+01, %40
  %mul195 = fmul float %sub194, %Rz_1
  %conv196 = fpext float %mul195 to double
  %add197 = fadd double %add191, %conv196
  %mul198 = fmul double %add197, %conv
  %conv199 = fptrunc double %mul198 to float
  br label %if.end363

if.else200:                                       ; preds = %if.else161
  br i1 %cmp56, label %if.then203, label %if.else255

if.then203:                                       ; preds = %if.else200
  %43 = add nsw i64 %indvars.iv, %5
  %arrayidx208 = getelementptr inbounds float, float* %power, i64 %43
  %44 = load float, float* %arrayidx208, align 4, !tbaa !8
  %conv209 = fpext float %44 to double
  %45 = add nsw i64 %indvars.iv, %9
  %arrayidx214 = getelementptr inbounds float, float* %temp, i64 %45
  %46 = load float, float* %arrayidx214, align 4, !tbaa !8
  %47 = add nsw i64 %indvars.iv, %7
  %arrayidx219 = getelementptr inbounds float, float* %temp, i64 %47
  %48 = load float, float* %arrayidx219, align 4, !tbaa !8
  %add220 = fadd float %46, %48
  %conv221 = fpext float %add220 to double
  %arrayidx225 = getelementptr inbounds float, float* %temp, i64 %43
  %49 = load float, float* %arrayidx225, align 4, !tbaa !8
  %conv226 = fpext float %49 to double
  %mul227 = fmul double %conv226, 2.000000e+00
  %sub228 = fsub double %conv221, %mul227
  %mul230 = fmul double %sub228, %conv229
  %add231 = fadd double %mul230, %conv209
  %50 = add nsw i64 %43, -1
  %arrayidx236 = getelementptr inbounds float, float* %temp, i64 %50
  %51 = load float, float* %arrayidx236, align 4, !tbaa !8
  %sub241 = fsub float %51, %49
  %mul242 = fmul float %sub241, %Rx_1
  %conv243 = fpext float %mul242 to double
  %add244 = fadd double %add231, %conv243
  %sub249 = fsub float 8.000000e+01, %49
  %mul250 = fmul float %sub249, %Rz_1
  %conv251 = fpext float %mul250 to double
  %add252 = fadd double %add244, %conv251
  %mul253 = fmul double %add252, %conv
  %conv254 = fptrunc double %mul253 to float
  br label %if.end363

if.else255:                                       ; preds = %if.else200
  br i1 %cmp84, label %if.then258, label %if.else310

if.then258:                                       ; preds = %if.else255
  %52 = add nsw i64 %indvars.iv, %5
  %arrayidx263 = getelementptr inbounds float, float* %power, i64 %52
  %53 = load float, float* %arrayidx263, align 4, !tbaa !8
  %conv264 = fpext float %53 to double
  %54 = add nsw i64 %52, 1
  %arrayidx269 = getelementptr inbounds float, float* %temp, i64 %54
  %55 = load float, float* %arrayidx269, align 4, !tbaa !8
  %56 = add nsw i64 %52, -1
  %arrayidx274 = getelementptr inbounds float, float* %temp, i64 %56
  %57 = load float, float* %arrayidx274, align 4, !tbaa !8
  %add275 = fadd float %55, %57
  %conv276 = fpext float %add275 to double
  %arrayidx280 = getelementptr inbounds float, float* %temp, i64 %52
  %58 = load float, float* %arrayidx280, align 4, !tbaa !8
  %conv281 = fpext float %58 to double
  %mul282 = fmul double %conv281, 2.000000e+00
  %sub283 = fsub double %conv276, %mul282
  %mul285 = fmul double %sub283, %conv180
  %add286 = fadd double %mul285, %conv264
  %59 = add nsw i64 %indvars.iv, %7
  %arrayidx291 = getelementptr inbounds float, float* %temp, i64 %59
  %60 = load float, float* %arrayidx291, align 4, !tbaa !8
  %sub296 = fsub float %60, %58
  %mul297 = fmul float %sub296, %Ry_1
  %conv298 = fpext float %mul297 to double
  %add299 = fadd double %add286, %conv298
  %sub304 = fsub float 8.000000e+01, %58
  %mul305 = fmul float %sub304, %Rz_1
  %conv306 = fpext float %mul305 to double
  %add307 = fadd double %add299, %conv306
  %mul308 = fmul double %add307, %conv
  %conv309 = fptrunc double %mul308 to float
  br label %if.end363

if.else310:                                       ; preds = %if.else255
  br i1 %cmp36, label %if.then312, label %if.end363

if.then312:                                       ; preds = %if.else310
  %61 = load float, float* %arrayidx133, align 4, !tbaa !8
  %conv317 = fpext float %61 to double
  %62 = load float, float* %arrayidx321, align 4, !tbaa !8
  %63 = load float, float* %arrayidx147, align 4, !tbaa !8
  %add326 = fadd float %62, %63
  %conv327 = fpext float %add326 to double
  %64 = load float, float* %arrayidx140, align 4, !tbaa !8
  %conv331 = fpext float %64 to double
  %mul332 = fmul double %conv331, 2.000000e+00
  %sub333 = fsub double %conv327, %mul332
  %mul335 = fmul double %sub333, %conv229
  %add336 = fadd double %mul335, %conv317
  %65 = load float, float* %arrayidx137, align 4, !tbaa !8
  %sub344 = fsub float %65, %64
  %mul345 = fmul float %sub344, %Rx_1
  %conv346 = fpext float %mul345 to double
  %add347 = fadd double %add336, %conv346
  %sub351 = fsub float 8.000000e+01, %64
  %mul352 = fmul float %sub351, %Rz_1
  %conv353 = fpext float %mul352 to double
  %add354 = fadd double %add347, %conv353
  %mul355 = fmul double %add354, %conv
  %conv356 = fptrunc double %mul355 to float
  br label %if.end363

if.end363:                                        ; preds = %if.then312, %if.else310, %if.then258, %if.then203, %if.then163, %if.then130, %if.then88, %if.then57, %if.then37
  %delta.0.delta.0.774 = phi float [ %mul81, %if.then57 ], [ %mul160, %if.then130 ], [ %conv254, %if.then203 ], [ %delta.0.delta.0.773, %if.else310 ], [ %conv356, %if.then312 ], [ %conv309, %if.then258 ], [ %conv199, %if.then163 ], [ %mul124, %if.then88 ], [ %mul52, %if.then37 ]
  %66 = add nsw i64 %indvars.iv, %5
  %arrayidx367 = getelementptr inbounds float, float* %temp, i64 %66
  %67 = load float, float* %arrayidx367, align 4, !tbaa !8
  %add368 = fadd float %delta.0.delta.0.774, %67
  %arrayidx372 = getelementptr inbounds float, float* %result, i64 %66
  store float %add368, float* %arrayidx372, align 4, !tbaa !8
  %indvars.iv.next = add nsw i64 %indvars.iv, 1
  %cmp32 = icmp slt i64 %indvars.iv.next, %1
  br i1 %cmp32, label %for.body34, label %for.cond.cleanup33

if.end376:                                        ; preds = %pfor.body
  %68 = or i64 %0, 1
  %69 = icmp sgt i64 %68, %1
  %smax = select i1 %69, i64 %68, i64 %1
  %70 = sub nsw i64 %smax, %0
  %71 = mul nsw i64 %2, %idxprom
  %72 = add i64 %71, %0
  %73 = icmp sgt i64 %68, %1
  %smax837 = select i1 %73, i64 %68, i64 %1
  %74 = add i64 %smax837, %71
  %75 = add i64 %71, -1
  %76 = add i64 %75, %0
  %77 = add nsw i64 %2, -1
  %78 = mul i64 %77, %idxprom
  %79 = add i64 %78, %0
  %80 = add i64 %smax837, %78
  %81 = or i64 %2, 1
  %82 = mul nsw i64 %81, %idxprom
  %83 = add i64 %82, %0
  %84 = add i64 %smax837, %82
  %min.iters.check = icmp ult i64 %70, 4
  %n.vec = and i64 %70, -16
  %ind.end = add nsw i64 %n.vec, %0
  %cmp.n = icmp eq i64 %70, %n.vec
  br label %for.body382

for.body382:                                      ; preds = %for.cond.cleanup387, %if.end376
  %indvar = phi i64 [ 0, %if.end376 ], [ %indvar.next, %for.cond.cleanup387 ]
  %indvars.iv828 = phi i64 [ %2, %if.end376 ], [ %indvars.iv.next829, %for.cond.cleanup387 ]
  %85 = mul nsw i64 %indvar, %idxprom
  %86 = add i64 %72, %85
  %scevgep = getelementptr float, float* %result, i64 %86
  %87 = add i64 %74, %85
  %scevgep838 = getelementptr float, float* %result, i64 %87
  %88 = mul nsw i64 %indvars.iv828, %idxprom
  %indvars.iv.next829 = add nsw i64 %indvars.iv828, 1
  %89 = mul nsw i64 %indvars.iv.next829, %idxprom
  %90 = add nsw i64 %indvars.iv828, -1
  %91 = mul nsw i64 %90, %idxprom
  br i1 %min.iters.check, label %for.body388.preheader, label %vector.memcheck

for.body388.preheader:                            ; preds = %middle.block, %vector.memcheck, %for.body382
  %indvars.iv821.ph = phi i64 [ %0, %vector.memcheck ], [ %0, %for.body382 ], [ %ind.end, %middle.block ]
  br label %for.body388

vector.memcheck:                                  ; preds = %for.body382
  %scevgep854 = getelementptr float, float* %power, i64 %87
  %scevgep852 = getelementptr float, float* %power, i64 %86
  %92 = add i64 %84, %85
  %scevgep850 = getelementptr float, float* %temp, i64 %92
  %93 = add i64 %83, %85
  %scevgep848 = getelementptr float, float* %temp, i64 %93
  %94 = add i64 %80, %85
  %scevgep846 = getelementptr float, float* %temp, i64 %94
  %95 = add i64 %79, %85
  %scevgep844 = getelementptr float, float* %temp, i64 %95
  %96 = or i64 %71, 1
  %97 = add i64 %96, %smax837
  %98 = add i64 %97, %85
  %scevgep842 = getelementptr float, float* %temp, i64 %98
  %99 = add i64 %76, %85
  %scevgep840 = getelementptr float, float* %temp, i64 %99
  %bound0 = icmp ult float* %scevgep, %scevgep842
  %bound1 = icmp ult float* %scevgep840, %scevgep838
  %found.conflict = and i1 %bound0, %bound1
  %bound0856 = icmp ult float* %scevgep, %scevgep846
  %bound1857 = icmp ult float* %scevgep844, %scevgep838
  %found.conflict858 = and i1 %bound0856, %bound1857
  %conflict.rdx = or i1 %found.conflict, %found.conflict858
  %bound0859 = icmp ult float* %scevgep, %scevgep850
  %bound1860 = icmp ult float* %scevgep848, %scevgep838
  %found.conflict861 = and i1 %bound0859, %bound1860
  %conflict.rdx862 = or i1 %found.conflict861, %conflict.rdx
  %bound0863 = icmp ult float* %scevgep, %scevgep854
  %bound1864 = icmp ult float* %scevgep852, %scevgep838
  %found.conflict865 = and i1 %bound0863, %bound1864
  %conflict.rdx866 = or i1 %found.conflict865, %conflict.rdx862
  br i1 %conflict.rdx866, label %for.body388.preheader, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %100 = add i64 %index, %0
  %101 = add nsw i64 %100, %88
  %102 = getelementptr inbounds float, float* %temp, i64 %101
  %103 = bitcast float* %102 to <4 x float>*
  %wide.load = load <4 x float>, <4 x float>* %103, align 4, !tbaa !8, !alias.scope !10
  %104 = getelementptr inbounds float, float* %power, i64 %101
  %105 = bitcast float* %104 to <4 x float>*
  %wide.load867 = load <4 x float>, <4 x float>* %105, align 4, !tbaa !8, !alias.scope !13
  %106 = add nsw i64 %100, %89
  %107 = getelementptr inbounds float, float* %temp, i64 %106
  %108 = bitcast float* %107 to <4 x float>*
  %wide.load868 = load <4 x float>, <4 x float>* %108, align 4, !tbaa !8, !alias.scope !15
  %109 = add nsw i64 %100, %91
  %110 = getelementptr inbounds float, float* %temp, i64 %109
  %111 = bitcast float* %110 to <4 x float>*
  %wide.load869 = load <4 x float>, <4 x float>* %111, align 4, !tbaa !8, !alias.scope !17
  %112 = fadd <4 x float> %wide.load868, %wide.load869
  %113 = fmul <4 x float> %wide.load, <float 2.000000e+00, float 2.000000e+00, float 2.000000e+00, float 2.000000e+00>
  %114 = fsub <4 x float> %112, %113
  %115 = fmul <4 x float> %broadcast.splat871, %114
  %116 = fadd <4 x float> %wide.load867, %115
  %117 = add nsw i64 %101, 1
  %118 = getelementptr inbounds float, float* %temp, i64 %117
  %119 = bitcast float* %118 to <4 x float>*
  %wide.load872 = load <4 x float>, <4 x float>* %119, align 4, !tbaa !8, !alias.scope !10
  %120 = add nsw i64 %101, -1
  %121 = getelementptr inbounds float, float* %temp, i64 %120
  %122 = bitcast float* %121 to <4 x float>*
  %wide.load873 = load <4 x float>, <4 x float>* %122, align 4, !tbaa !8, !alias.scope !10
  %123 = fadd <4 x float> %wide.load872, %wide.load873
  %124 = fsub <4 x float> %123, %113
  %125 = fmul <4 x float> %broadcast.splat875, %124
  %126 = fadd <4 x float> %116, %125
  %127 = fsub <4 x float> <float 8.000000e+01, float 8.000000e+01, float 8.000000e+01, float 8.000000e+01>, %wide.load
  %128 = fmul <4 x float> %broadcast.splat877, %127
  %129 = fadd <4 x float> %128, %126
  %130 = fmul <4 x float> %broadcast.splat879, %129
  %131 = fadd <4 x float> %wide.load, %130
  %132 = getelementptr inbounds float, float* %result, i64 %101
  %133 = bitcast float* %132 to <4 x float>*
  store <4 x float> %131, <4 x float>* %133, align 4, !tbaa !8, !alias.scope !19, !noalias !21
  %index.next = add i64 %index, 4
  %134 = icmp eq i64 %index.next, %n.vec
  br i1 %134, label %middle.block, label %vector.body, !llvm.loop !22

middle.block:                                     ; preds = %vector.body
  br i1 %cmp.n, label %for.cond.cleanup387, label %for.body388.preheader

for.cond.cleanup387.loopexit:                     ; preds = %for.body388
  br label %for.cond.cleanup387

for.cond.cleanup387:                              ; preds = %for.cond.cleanup387.loopexit, %middle.block
  %cmp380 = icmp slt i64 %indvars.iv.next829, %3
  %indvar.next = add nuw nsw i64 %indvar, 1
  br i1 %cmp380, label %for.body382, label %cleanup.cont462.loopexit

for.body388:                                      ; preds = %for.body388, %for.body388.preheader
  %indvars.iv821 = phi i64 [ %indvars.iv.next822, %for.body388 ], [ %indvars.iv821.ph, %for.body388.preheader ]
  %135 = add nsw i64 %indvars.iv821, %88
  %arrayidx392 = getelementptr inbounds float, float* %temp, i64 %135
  %136 = load float, float* %arrayidx392, align 4, !tbaa !8
  %arrayidx396 = getelementptr inbounds float, float* %power, i64 %135
  %137 = load float, float* %arrayidx396, align 4, !tbaa !8
  %138 = add nsw i64 %indvars.iv821, %89
  %arrayidx401 = getelementptr inbounds float, float* %temp, i64 %138
  %139 = load float, float* %arrayidx401, align 4, !tbaa !8
  %140 = add nsw i64 %indvars.iv821, %91
  %arrayidx406 = getelementptr inbounds float, float* %temp, i64 %140
  %141 = load float, float* %arrayidx406, align 4, !tbaa !8
  %add407 = fadd float %139, %141
  %mul412 = fmul float %136, 2.000000e+00
  %sub413 = fsub float %add407, %mul412
  %mul414 = fmul float %sub413, %Ry_1
  %add415 = fadd float %137, %mul414
  %142 = add nsw i64 %135, 1
  %arrayidx420 = getelementptr inbounds float, float* %temp, i64 %142
  %143 = load float, float* %arrayidx420, align 4, !tbaa !8
  %144 = add nsw i64 %135, -1
  %arrayidx425 = getelementptr inbounds float, float* %temp, i64 %144
  %145 = load float, float* %arrayidx425, align 4, !tbaa !8
  %add426 = fadd float %143, %145
  %sub432 = fsub float %add426, %mul412
  %mul433 = fmul float %sub432, %Rx_1
  %add434 = fadd float %add415, %mul433
  %sub439 = fsub float 8.000000e+01, %136
  %mul440 = fmul float %sub439, %Rz_1
  %add441 = fadd float %mul440, %add434
  %mul442 = fmul float %add441, %Cap_1
  %add443 = fadd float %136, %mul442
  %arrayidx447 = getelementptr inbounds float, float* %result, i64 %135
  store float %add443, float* %arrayidx447, align 4, !tbaa !8
  %indvars.iv.next822 = add nsw i64 %indvars.iv821, 1
  %cmp386 = icmp slt i64 %indvars.iv.next822, %1
  br i1 %cmp386, label %for.body388, label %for.cond.cleanup387.loopexit, !llvm.loop !25

cleanup.cont462.loopexit:                         ; preds = %for.cond.cleanup387
  br label %cleanup.cont462

cleanup.cont462.loopexit1:                        ; preds = %for.cond.cleanup33
  br label %cleanup.cont462

cleanup.cont462:                                  ; preds = %cleanup.cont462.loopexit1, %cleanup.cont462.loopexit
  reattach within %syncreg, label %pfor.inc

pfor.inc:                                         ; preds = %cleanup.cont462, %pfor.detach
  %inc463 = add nuw nsw i32 %__begin.0781, 1
  %exitcond = icmp eq i32 %inc463, %div
  br i1 %exitcond, label %pfor.cond.cleanup.loopexit, label %pfor.detach, !llvm.loop !26
}

; Function Attrs: argmemonly nounwind
declare token @llvm.syncregion.start() #1

; Function Attrs: nounwind uwtable
define void @_Z17compute_tran_tempPfiS_S_ii(float* %result, i32 %num_iterations, float* %temp, float* nocapture readonly %power, i32 %row, i32 %col) local_unnamed_addr #0 {
entry:
  br label %entry.split

entry.split:                                      ; preds = %entry
  %conv = sitofp i32 %row to float
  %div = fdiv float 0x3F90624DE0000000, %conv
  %conv1 = sitofp i32 %col to float
  %div2 = fdiv float 0x3F90624DE0000000, %conv1
  %conv3 = fpext float %div2 to double
  %mul = fmul double %conv3, 0x407B580015CA2000
  %conv4 = fpext float %div to double
  %mul5 = fmul double %mul, %conv4
  %conv6 = fptrunc double %mul5 to float
  %mul9 = fmul double %conv4, 0x3FB99999AE000000
  %div10 = fdiv double %conv3, %mul9
  %conv11 = fptrunc double %div10 to float
  %mul14 = fmul double %conv3, 0x3FB99999AE000000
  %div15 = fdiv double %conv4, %mul14
  %conv16 = fptrunc double %div15 to float
  %mul17 = fmul float %div, 1.000000e+02
  %mul18 = fmul float %mul17, %div2
  %div19 = fdiv float 0x3F40624DE0000000, %mul18
  %div24 = fdiv float 1.000000e+00, %conv11
  %div25 = fdiv float 1.000000e+00, %conv16
  %div26 = fdiv float 1.000000e+00, %div19
  %div27 = fdiv float 0x3DE40B0E00000000, %conv6
  %cmp56 = icmp sgt i32 %num_iterations, 0
  br i1 %cmp56, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry.split
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry.split
  ret void

for.body:                                         ; preds = %for.body, %for.body.preheader
  %r.059 = phi float* [ %t.057, %for.body ], [ %result, %for.body.preheader ]
  %i.058 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %t.057 = phi float* [ %r.059, %for.body ], [ %temp, %for.body.preheader ]
  tail call void @_Z16single_iterationPfS_S_iifffff(float* %r.059, float* %t.057, float* %power, i32 %row, i32 %col, float %div27, float %div24, float %div25, float %div26, float undef)
  %inc = add nuw nsw i32 %i.058, 1
  %exitcond = icmp eq i32 %inc, %num_iterations
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}

; Function Attrs: noreturn nounwind uwtable
define void @_Z5fatalPKc(i8* %s) local_unnamed_addr #3 {
entry:
  br label %entry.split

entry.split:                                      ; preds = %entry
  %0 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !28
  %call = tail call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %0, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* %s) #7
  tail call void @exit(i32 1) #8
  unreachable
}

; Function Attrs: nounwind
declare i32 @fprintf(%struct._IO_FILE* nocapture, i8* nocapture readonly, ...) local_unnamed_addr #2

; Function Attrs: noreturn nounwind
declare void @exit(i32) local_unnamed_addr #4

; Function Attrs: nounwind uwtable
define void @_Z11writeoutputPfiiPc(float* nocapture readonly %vect, i32 %grid_rows, i32 %grid_cols, i8* nocapture readonly %file) local_unnamed_addr #0 {
entry:
  %str = alloca [256 x i8], align 16
  br label %entry.split

entry.split:                                      ; preds = %entry
  %0 = getelementptr inbounds [256 x i8], [256 x i8]* %str, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull %0) #6
  %call = tail call %struct._IO_FILE* @fopen(i8* %file, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %cmp = icmp eq %struct._IO_FILE* %call, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry.split
  %puts = tail call i32 @puts(i8* getelementptr inbounds ([24 x i8], [24 x i8]* @str, i64 0, i64 0))
  br label %if.end

if.end:                                           ; preds = %if.then, %entry.split
  %cmp228 = icmp sgt i32 %grid_rows, 0
  %cmp425 = icmp sgt i32 %grid_cols, 0
  %or.cond = and i1 %cmp228, %cmp425
  br i1 %or.cond, label %for.body.lr.ph.split.us, label %for.end12

for.body.lr.ph.split.us:                          ; preds = %if.end
  %1 = sext i32 %grid_cols to i64
  %wide.trip.count = zext i32 %grid_cols to i64
  %wide.trip.count36 = zext i32 %grid_rows to i64
  br label %for.body.us

for.body.us:                                      ; preds = %for.cond3.for.inc10_crit_edge.us, %for.body.lr.ph.split.us
  %indvars.iv33 = phi i64 [ %indvars.iv.next34, %for.cond3.for.inc10_crit_edge.us ], [ 0, %for.body.lr.ph.split.us ]
  %index.029.us = phi i32 [ %5, %for.cond3.for.inc10_crit_edge.us ], [ 0, %for.body.lr.ph.split.us ]
  %2 = mul nsw i64 %indvars.iv33, %1
  br label %for.body5.us

for.body5.us:                                     ; preds = %for.body5.us, %for.body.us
  %indvars.iv = phi i64 [ 0, %for.body.us ], [ %indvars.iv.next, %for.body5.us ]
  %index.127.us = phi i32 [ %index.029.us, %for.body.us ], [ %inc.us, %for.body5.us ]
  %3 = add nsw i64 %indvars.iv, %2
  %arrayidx.us = getelementptr inbounds float, float* %vect, i64 %3
  %4 = load float, float* %arrayidx.us, align 4, !tbaa !8
  %conv.us = fpext float %4 to double
  %call6.us = call i32 (i8*, i8*, ...) @sprintf(i8* nonnull %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i64 0, i64 0), i32 %index.127.us, double %conv.us) #6
  %call8.us = call i32 @fputs(i8* nonnull %0, %struct._IO_FILE* %call)
  %inc.us = add nsw i32 %index.127.us, 1
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.cond3.for.inc10_crit_edge.us, label %for.body5.us

for.cond3.for.inc10_crit_edge.us:                 ; preds = %for.body5.us
  %5 = add i32 %index.029.us, %grid_cols
  %indvars.iv.next34 = add nuw nsw i64 %indvars.iv33, 1
  %exitcond37 = icmp eq i64 %indvars.iv.next34, %wide.trip.count36
  br i1 %exitcond37, label %for.end12.loopexit, label %for.body.us

for.end12.loopexit:                               ; preds = %for.cond3.for.inc10_crit_edge.us
  br label %for.end12

for.end12:                                        ; preds = %for.end12.loopexit, %if.end
  %call13 = tail call i32 @fclose(%struct._IO_FILE* %call)
  call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull %0) #6
  ret void
}

; Function Attrs: nounwind
declare noalias %struct._IO_FILE* @fopen(i8* nocapture readonly, i8* nocapture readonly) local_unnamed_addr #2

; Function Attrs: nounwind
declare i32 @printf(i8* nocapture readonly, ...) local_unnamed_addr #2

; Function Attrs: nounwind
declare i32 @sprintf(i8* nocapture, i8* nocapture readonly, ...) local_unnamed_addr #2

; Function Attrs: nounwind
declare i32 @fputs(i8* nocapture readonly, %struct._IO_FILE* nocapture) local_unnamed_addr #2

; Function Attrs: nounwind
declare i32 @fclose(%struct._IO_FILE* nocapture) local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define void @_Z10read_inputPfiiPc(float* nocapture %vect, i32 %grid_rows, i32 %grid_cols, i8* nocapture readonly %file) local_unnamed_addr #0 {
entry:
  %str = alloca [256 x i8], align 16
  %val = alloca float, align 4
  br label %entry.split

entry.split:                                      ; preds = %entry
  %0 = getelementptr inbounds [256 x i8], [256 x i8]* %str, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull %0) #6
  %1 = bitcast float* %val to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %1) #6
  %call = tail call %struct._IO_FILE* @fopen(i8* %file, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i64 0, i64 0))
  %tobool = icmp eq %struct._IO_FILE* %call, null
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry.split
  tail call void @_Z5fatalPKc(i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.5, i64 0, i64 0))
  unreachable

if.end:                                           ; preds = %entry.split
  %mul = mul nsw i32 %grid_cols, %grid_rows
  %cmp20 = icmp sgt i32 %mul, 0
  br i1 %cmp20, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %if.end
  %2 = bitcast float* %val to i32*
  %3 = sext i32 %mul to i64
  br label %for.body

for.body:                                         ; preds = %if.end10, %for.body.lr.ph
  %indvars.iv = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next, %if.end10 ]
  %call1 = call i8* @fgets(i8* nonnull %0, i32 256, %struct._IO_FILE* nonnull %call)
  %call2 = call i32 @feof(%struct._IO_FILE* nonnull %call) #6
  %tobool3 = icmp eq i32 %call2, 0
  br i1 %tobool3, label %if.end5, label %if.then4

if.then4:                                         ; preds = %for.body
  call void @_Z5fatalPKc(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.6, i64 0, i64 0))
  unreachable

if.end5:                                          ; preds = %for.body
  %call7 = call i32 (i8*, i8*, ...) @sscanf(i8* nonnull %0, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.7, i64 0, i64 0), float* nonnull %val) #6
  %cmp8 = icmp eq i32 %call7, 1
  br i1 %cmp8, label %if.end10, label %if.then9

if.then9:                                         ; preds = %if.end5
  call void @_Z5fatalPKc(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.8, i64 0, i64 0))
  unreachable

if.end10:                                         ; preds = %if.end5
  %4 = load i32, i32* %2, align 4, !tbaa !8
  %arrayidx = getelementptr inbounds float, float* %vect, i64 %indvars.iv
  %5 = bitcast float* %arrayidx to i32*
  store i32 %4, i32* %5, align 4, !tbaa !8
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %cmp = icmp slt i64 %indvars.iv.next, %3
  br i1 %cmp, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %if.end10
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %if.end
  %call11 = call i32 @fclose(%struct._IO_FILE* nonnull %call)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %1) #6
  call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull %0) #6
  ret void
}

; Function Attrs: nounwind
declare i8* @fgets(i8*, i32, %struct._IO_FILE* nocapture) local_unnamed_addr #2

; Function Attrs: nounwind
declare i32 @feof(%struct._IO_FILE* nocapture) local_unnamed_addr #2

; Function Attrs: nounwind
declare i32 @sscanf(i8* nocapture readonly, i8* nocapture readonly, ...) local_unnamed_addr #2

; Function Attrs: noreturn nounwind uwtable
define void @_Z5usageiPPc(i32 %argc, i8** nocapture readonly %argv) local_unnamed_addr #3 {
entry:
  br label %entry.split

entry.split:                                      ; preds = %entry
  %0 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !28
  %1 = load i8*, i8** %argv, align 8, !tbaa !28
  %call = tail call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %0, i8* getelementptr inbounds ([87 x i8], [87 x i8]* @.str.9, i64 0, i64 0), i8* %1) #7
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !28
  %3 = tail call i64 @fwrite(i8* getelementptr inbounds ([63 x i8], [63 x i8]* @.str.10, i64 0, i64 0), i64 62, i64 1, %struct._IO_FILE* %2) #7
  %4 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !28
  %5 = tail call i64 @fwrite(i8* getelementptr inbounds ([66 x i8], [66 x i8]* @.str.11, i64 0, i64 0), i64 65, i64 1, %struct._IO_FILE* %4) #7
  %6 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !28
  %7 = tail call i64 @fwrite(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.12, i64 0, i64 0), i64 37, i64 1, %struct._IO_FILE* %6) #7
  %8 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !28
  %9 = tail call i64 @fwrite(i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.13, i64 0, i64 0), i64 40, i64 1, %struct._IO_FILE* %8) #7
  %10 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !28
  %11 = tail call i64 @fwrite(i8* getelementptr inbounds ([89 x i8], [89 x i8]* @.str.14, i64 0, i64 0), i64 88, i64 1, %struct._IO_FILE* %10) #7
  %12 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !28
  %13 = tail call i64 @fwrite(i8* getelementptr inbounds ([86 x i8], [86 x i8]* @.str.15, i64 0, i64 0), i64 85, i64 1, %struct._IO_FILE* %12) #7
  %14 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !28
  %15 = tail call i64 @fwrite(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.16, i64 0, i64 0), i64 41, i64 1, %struct._IO_FILE* %14) #7
  tail call void @exit(i32 1) #8
  unreachable
}

; Function Attrs: norecurse nounwind uwtable
define i32 @main(i32 %argc, i8** nocapture readonly %argv) local_unnamed_addr #5 {
entry:
  %tv.i83 = alloca %struct.timeval, align 8
  %tv.i = alloca %struct.timeval, align 8
  br label %entry.split

entry.split:                                      ; preds = %entry
  %cmp = icmp eq i32 %argc, 7
  br i1 %cmp, label %if.end, label %if.then

if.then:                                          ; preds = %entry.split
  tail call void @_Z5usageiPPc(i32 undef, i8** %argv)
  unreachable

if.end:                                           ; preds = %entry.split
  %arrayidx = getelementptr inbounds i8*, i8** %argv, i64 1
  %0 = load i8*, i8** %arrayidx, align 8, !tbaa !28
  %call.i = tail call i64 @strtol(i8* nocapture nonnull %0, i8** null, i32 10) #6
  %conv.i = trunc i64 %call.i to i32
  %cmp1 = icmp slt i32 %conv.i, 1
  br i1 %cmp1, label %if.then9, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.end
  %arrayidx2 = getelementptr inbounds i8*, i8** %argv, i64 2
  %1 = load i8*, i8** %arrayidx2, align 8, !tbaa !28
  %call.i76 = tail call i64 @strtol(i8* nocapture nonnull %1, i8** null, i32 10) #6
  %conv.i77 = trunc i64 %call.i76 to i32
  %cmp4 = icmp slt i32 %conv.i77, 1
  br i1 %cmp4, label %if.then9, label %lor.lhs.false5

lor.lhs.false5:                                   ; preds = %lor.lhs.false
  %arrayidx6 = getelementptr inbounds i8*, i8** %argv, i64 3
  %2 = load i8*, i8** %arrayidx6, align 8, !tbaa !28
  %call.i78 = tail call i64 @strtol(i8* nocapture nonnull %2, i8** null, i32 10) #6
  %conv.i79 = trunc i64 %call.i78 to i32
  %cmp8 = icmp slt i32 %conv.i79, 1
  br i1 %cmp8, label %if.then9, label %if.end10

if.then9:                                         ; preds = %lor.lhs.false5, %lor.lhs.false, %if.end
  tail call void @_Z5usageiPPc(i32 undef, i8** nonnull %argv)
  unreachable

if.end10:                                         ; preds = %lor.lhs.false5
  %mul = shl i64 %call.i, 32
  %sext = mul i64 %mul, %call.i76
  %conv = ashr exact i64 %sext, 32
  %call11 = tail call noalias i8* @calloc(i64 %conv, i64 4) #6
  %3 = bitcast i8* %call11 to float*
  %call14 = tail call noalias i8* @calloc(i64 %conv, i64 4) #6
  %4 = bitcast i8* %call14 to float*
  %call17 = tail call noalias i8* @calloc(i64 %conv, i64 4) #6
  %5 = bitcast i8* %call17 to float*
  %tobool = icmp ne i8* %call11, null
  %tobool19 = icmp ne i8* %call14, null
  %or.cond = and i1 %tobool, %tobool19
  br i1 %or.cond, label %for.body.lr.ph.i, label %if.then20

if.then20:                                        ; preds = %if.end10
  tail call void @_Z5fatalPKc(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.17, i64 0, i64 0))
  unreachable

for.body.lr.ph.i:                                 ; preds = %if.end10
  %arrayidx22 = getelementptr inbounds i8*, i8** %argv, i64 4
  %6 = load i8*, i8** %arrayidx22, align 8, !tbaa !28
  %arrayidx23 = getelementptr inbounds i8*, i8** %argv, i64 5
  %7 = load i8*, i8** %arrayidx23, align 8, !tbaa !28
  %arrayidx24 = getelementptr inbounds i8*, i8** %argv, i64 6
  %8 = load i8*, i8** %arrayidx24, align 8, !tbaa !28
  tail call void @_Z10read_inputPfiiPc(float* %3, i32 %conv.i, i32 %conv.i77, i8* %6)
  tail call void @_Z10read_inputPfiiPc(float* %4, i32 %conv.i, i32 %conv.i77, i8* %7)
  %puts = tail call i32 @puts(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @str.21, i64 0, i64 0))
  %9 = bitcast %struct.timeval* %tv.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %9) #6
  %call.i80 = call i32 @gettimeofday(%struct.timeval* nonnull %tv.i, %struct.timezone* null) #6
  %tv_sec.i = getelementptr inbounds %struct.timeval, %struct.timeval* %tv.i, i64 0, i32 0
  %10 = load i64, i64* %tv_sec.i, align 8, !tbaa !2
  %tv_usec.i = getelementptr inbounds %struct.timeval, %struct.timeval* %tv.i, i64 0, i32 1
  %11 = load i64, i64* %tv_usec.i, align 8, !tbaa !7
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %9) #6
  %conv.i81 = sitofp i32 %conv.i to float
  %div.i = fdiv float 0x3F90624DE0000000, %conv.i81
  %conv1.i = sitofp i32 %conv.i77 to float
  %div2.i = fdiv float 0x3F90624DE0000000, %conv1.i
  %conv3.i = fpext float %div2.i to double
  %mul.i82 = fmul double %conv3.i, 0x407B580015CA2000
  %conv4.i = fpext float %div.i to double
  %mul5.i = fmul double %mul.i82, %conv4.i
  %conv6.i = fptrunc double %mul5.i to float
  %mul9.i = fmul double %conv4.i, 0x3FB99999AE000000
  %div10.i = fdiv double %conv3.i, %mul9.i
  %conv11.i = fptrunc double %div10.i to float
  %mul14.i = fmul double %conv3.i, 0x3FB99999AE000000
  %div15.i = fdiv double %conv4.i, %mul14.i
  %conv16.i = fptrunc double %div15.i to float
  %mul17.i = fmul float %div.i, 1.000000e+02
  %mul18.i = fmul float %mul17.i, %div2.i
  %div19.i = fdiv float 0x3F40624DE0000000, %mul18.i
  %div24.i = fdiv float 1.000000e+00, %conv11.i
  %div25.i = fdiv float 1.000000e+00, %conv16.i
  %div26.i = fdiv float 1.000000e+00, %div19.i
  %div27.i = fdiv float 0x3DE40B0E00000000, %conv6.i
  br label %for.body.i

for.body.i:                                       ; preds = %for.body.i, %for.body.lr.ph.i
  %r.059.i = phi float* [ %5, %for.body.lr.ph.i ], [ %t.057.i, %for.body.i ]
  %i.058.i = phi i32 [ 0, %for.body.lr.ph.i ], [ %inc.i, %for.body.i ]
  %t.057.i = phi float* [ %3, %for.body.lr.ph.i ], [ %r.059.i, %for.body.i ]
  tail call void @_Z16single_iterationPfS_S_iifffff(float* %r.059.i, float* %t.057.i, float* %4, i32 %conv.i, i32 %conv.i77, float %div27.i, float %div24.i, float %div25.i, float %div26.i, float undef) #6
  %inc.i = add nuw nsw i32 %i.058.i, 1
  %exitcond.i = icmp eq i32 %inc.i, %conv.i79
  br i1 %exitcond.i, label %_Z17compute_tran_tempPfiS_S_ii.exit, label %for.body.i

_Z17compute_tran_tempPfiS_S_ii.exit:              ; preds = %for.body.i
  %12 = bitcast %struct.timeval* %tv.i83 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %12) #6
  %call.i84 = call i32 @gettimeofday(%struct.timeval* nonnull %tv.i83, %struct.timezone* null) #6
  %tv_sec.i85 = getelementptr inbounds %struct.timeval, %struct.timeval* %tv.i83, i64 0, i32 0
  %13 = load i64, i64* %tv_sec.i85, align 8, !tbaa !2
  %tv_usec.i87 = getelementptr inbounds %struct.timeval, %struct.timeval* %tv.i83, i64 0, i32 1
  %14 = load i64, i64* %tv_usec.i87, align 8, !tbaa !7
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %12) #6
  %puts75 = tail call i32 @puts(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.22, i64 0, i64 0))
  %tmp = sub i64 %13, %10
  %tmp89 = mul i64 %tmp, 1000000
  %add.i88 = sub i64 %14, %11
  %sub = add i64 %add.i88, %tmp89
  %conv29 = sitofp i64 %sub to float
  %div = fdiv float %conv29, 1.000000e+06
  %conv30 = fpext float %div to double
  %call31 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.20, i64 0, i64 0), double %conv30)
  %and = and i32 %conv.i79, 1
  %tobool32 = icmp eq i32 %and, 0
  %cond = select i1 %tobool32, float* %3, float* %5
  tail call void @_Z11writeoutputPfiiPc(float* %cond, i32 %conv.i, i32 %conv.i77, i8* %8)
  tail call void @free(i8* %call11) #6
  tail call void @free(i8* %call14) #6
  ret i32 0
}

; Function Attrs: nounwind
declare noalias i8* @calloc(i64, i64) local_unnamed_addr #2

; Function Attrs: nounwind
declare void @free(i8* nocapture) local_unnamed_addr #2

; Function Attrs: nounwind
declare i64 @strtol(i8* readonly, i8** nocapture, i32) local_unnamed_addr #2

; Function Attrs: nounwind
declare i32 @puts(i8* nocapture readonly) #6

; Function Attrs: nounwind
declare i64 @fwrite(i8* nocapture, i64, i64, %struct._IO_FILE* nocapture) #6

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind }
attributes #7 = { cold }
attributes #8 = { noreturn nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 5.0.0 (https://github.com/wsmoses/Cilk-Clang.git 2637f015d66418964aa0225534c004dd71a174b8) (git@github.com:wsmoses/Parallel-IR.git 465c2a2eaf1428531ca28017a0a1468b279916ec)"}
!2 = !{!3, !4, i64 0}
!3 = !{!"_ZTS7timeval", !4, i64 0, !4, i64 8}
!4 = !{!"long", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{!3, !4, i64 8}
!8 = !{!9, !9, i64 0}
!9 = !{!"float", !5, i64 0}
!10 = !{!11}
!11 = distinct !{!11, !12}
!12 = distinct !{!12, !"LVerDomain"}
!13 = !{!14}
!14 = distinct !{!14, !12}
!15 = !{!16}
!16 = distinct !{!16, !12}
!17 = !{!18}
!18 = distinct !{!18, !12}
!19 = !{!20}
!20 = distinct !{!20, !12}
!21 = !{!11, !18, !16, !14}
!22 = distinct !{!22, !23, !24}
!23 = !{!"llvm.loop.vectorize.width", i32 1}
!24 = !{!"llvm.loop.interleave.count", i32 1}
!25 = distinct !{!25, !23, !24}
!26 = distinct !{!26, !27}
!27 = !{!"tapir.loop.spawn.strategy", i32 1}
!28 = !{!29, !29, i64 0}
!29 = !{!"any pointer", !5, i64 0}

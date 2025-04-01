#set text(lang: "zh")
#set page(
  margin: (
    top: 2.54cm,
    bottom: 2.54cm,
    left: 3.17cm,
  ),
  numbering: "I"
)
#set text(12pt, font:("Times New Roman", "Songti SC")) //会自动匹配前面的是英语字体，后面的是中文字体
#show strong: set text(weight: 900)  // Songti SC 700 不够粗
#set par(leading: 1.5em)

// 局部作用域
#[
#set text(20pt, font: ("Times New Roman", "Heiti SC"))
#set par(leading: 0.5em)
#align(center, [#image("pic/sjtu-text.png") #scale(y: 88%)[SHANGHAI JIAO TONG UNIVERSITY]])
#align(center, [本科生毕业设计（论文）中期检查报告])
#v(1.5cm)
#align(center)[#image("pic/sjtu.png", height: 25%)]
]

\ \

#[
#import "@preview/cuti:0.2.1": show-cn-fakebold
#set text(14pt)
#show: show-cn-fakebold

#show table.cell: it => {
  if it.x == 0 {
    it
  } else {
    align(center, it)
  }
}

#set text(font: ("Kaiti", "Times New Roman"))

#table(
  columns: (0.8fr, 2.5fr),
  inset: 7pt,
  align: horizon,
  stroke: (x, y) => (
    y: if y > 0 and x == 1 { 0.5pt }
  ),
  [论文题目], [基于优化的快速、高自由度的机器人运动生成方法],
  [学生姓名:], [方俊杰],
  [学生学号:], [521260910018],
  [专 #h(20pt) 业:], [信息工程],
  [指导教师:], [卢策吾],
  [学院（系）], [巴黎卓越工程师学院],
)
]

#pagebreak()

#[
#set text(16pt, font: ("Times New Roman", "Songti SC"))
#align(center, text(font: "SimHei", weight: 900)[*填 表 说 明*])

#set text(14pt, font: ("Times New Roman", "Songti SC"))
+ 请每位学生根据学校及院（系）检查的要求认真进行自查，及时发现课题研究过程中存在的问题，分析原因，并提出解决思路和措施，明确下一阶段任务。 
+ 每位学生应根据项目实施情况认真、实事求是填写。填写字体请用宋体小四号，并用A4纸打印，于左侧装订成册。 
+ 毕业设计（论文）中期检查报告总字数应满足本院（系）要求。
+ 该表填写完毕后，须请指导教师审核，并签署意见。
+ 《上海交通大学本科生毕业设计（论文）中期检查报告》将作为答辩资格审查的主要材料之一。
+ 本表格不够可自行扩页。  
]

#set page(
  margin: (
    top: 2.54cm + 1cm,
    bottom: 2.54cm,
    left: 3.17cm,
  ),
    header: [
    #set text(10pt)
    #grid(columns: (50%, 35%), gutter: 15%, [#image("pic/sjtu-header.png", height: 1.1cm)], [毕业设计（论文）中期检查报告] )
    #line(length: 100%, stroke: 0.35pt)
    ],
)

#pagebreak()

// [正文设置]
#set page(numbering: "1")
#counter(page).update(1)
#counter(figure).update(1)
#set par(first-line-indent: 2em)

#let fakepar=context{box();v(-measure(block()+block()).height)}
#show heading: it=>it+fakepar
#show figure: it=>it+fakepar
#show math.equation.where(block: true): it=>it+fakepar

#show heading: it => {
  set text(font: ("Times New Roman", "Heiti SC"))
  h(-2em)
  it
  v(1em)
}
#show heading.where(level: 1): it => {
  set text(font: ("Times New Roman", "Heiti SC"))
  align(center)[#it.body]
}
#show figure.caption: it => {
  set text(10pt)
  it
}

#table(
  columns: (1fr),
  stroke: 0.45pt,
  [
#text(font: "SimHei")[课题进展情况：]

#[
  #show table.cell.where(y: 0): set text(weight: 900)
  #show figure: set block(breakable: true)

  #figure(
    table(
      columns: 3,
      fill: (_, y) => if y == 0 { gray.lighten(75%) },

      table.header[各阶段内容][阶段开始时间][备注],
      [表述机器人运动的优化目标，实现优化算法代码。], [24/12/1],  [完成],
      [提速轨迹生成部分的算法，可使机器人运动更平滑且不依赖运动目标优化的时延稳定性。], [25/1/1],  [完成],
      [提升优化算法的效率。], [25/2/21], [完成],
      [使用新的遥操作系统完成高自由度的、自定义的遥操作任务，收集数据。], [25/3/1], [完成],
      [设计新的高效演示接口 (Demonstration Interface)，推动数据收集的 Scaling up ], [25/4/12], [待完成],
      [应用于机械臂夹爪 Diffusion Policy Model 的模仿学习。], [25/4/15], [已完成],
      [实验验证从遥操作数据收集到夹爪和灵巧模仿学习策略模型完整流程的可行性。], [25/5/15], [],
    )
  )
]
  ], [
#text(font: "SimHei")[课题研究已取得的阶段性成果：]


一、使用基于 Quest3 的手部姿态检测器和包含优化目标、轨迹生成算法的遥操作系统收集高质量的遥操作数据，准备用于训练和复现 Diffusion Policy 模型。

#figure(image("pic/018.jpg", width: 40%), caption: "收集手腕和手指灵巧运动数据")

二、改进逆解优化的目标函数，优化算法效率。在IK求解器中，将势场梯度 ∇U_total 作为附加约束项加入QP优化问题，保持低于 100ms 的端到端延迟。

三、完善在线轨迹插值算法的理论部分，推导相关公式。

#figure(image("pic/008.png", width: 45%), caption: "多级自由度在线插值结果")

$
q = limits("argmin")_q space f(q) "s.t." space l_i <= q_i <= u_i
$

逆运动学损失函数: $f(q) = sum_(i = 1)^(k) w_i f_i (q, Omega_i)$

包含 4 种损失函数：

$
"帧目标" &: lr(||log("FK"(q, Omega)^or)||) \
"帧差" &: sum_(i = 1)
^(d) w_d lr(|| log("FK"((q_(t - 1), Omega)^(-1)"FK"(q_t, Omega))^or)||) \
"关节角度变化量" &: sum_(i = 1)^(d) w_d (q_(t - 1) - q_t)^2 \
// \min_{\Delta q} \|J\Delta q - \Delta x\|^2 + \lambda\|\Delta q\|^2 + \gamma\|\nabla U_{total}\|^2
"碰撞势场" &: min_(Delta q) J Delta q - Delta x^2 + lambda Delta q^2 + gamma nabla U_("total")^2
$

急动度约束：$j_min <= j_i <= j_max$

#figure(image("pic/019.png", width: 45%), caption: "急动度约束条件下最快轨迹插值结果")

该条件下，我们得到时间关于距离的反函数，对于特定的距离，我们将求出的 $t$ 代入到速度、加速度和急动度的公式中，并让机械臂当前急动度尽可能接近期望急动度。

四、完成相关核心文献（如Diffusion Policy、ALOHA等）的整理，梳理了现有机器人模仿学习的三大数据收集范式（实验室遥操作、人类视频、手持夹爪演示）。在硬件开发方面，已完成手腕支架的3D打印与组装，并复现了UMI (Universal Manipulation Interface) 硬件原型。

UMI的核心设计：

硬件设计：鱼眼镜头+侧镜的立体视觉增强、IMU辅助姿态跟踪。

策略接口：相对轨迹动作表示、延迟匹配机制、扩散策略（Diffusion Policy）应对动作多模态。

#figure(image("pic/017.jpg", width: 40%), caption: "使用实验室 3D 打印的 UMI 数据收集平行夹爪")

五、硬件系统更新：新的硬件平台采用模块化设计理念，包含可穿戴式数据采集单元和机器人执行单元。数据采集端整合了3D打印手腕支架、iPhone视觉模块和惯性测量单元（IMU），支持有雷达 / 无雷达两种工作模式。特别设计的鱼眼镜头适配器扩展了RealSense相机的视场角，使其更适合近距离操作场景。机器人端采用7自由度机械臂配置，通过自定义的相机云台实现主动视觉跟踪。系统支持多种人机交互模式，包括基于VR头显的沉浸式遥操作和基于手机AR界面的轻量化控制方案。

我们选择 iPhone 作为新的数据收集设备，探索数据收集 Scaling up 的可行性。其 ARKit功能，确认其可在无LiDAR的情况下完成SLAM任务，但需进一步验证其精度与稳定性。在有 LiDAR 的条件下，我们测量了 SLAM 定位精度，其 rotation 误差在 0.2 度内，translation 精度则在 0.5cm 之内。此外，设计了可穿戴夹爪指头以增强数据采集的灵活性。

为支持模仿学习算法的训练，我们开发了标准化的数据采集 pipeline。iPhone端应用实现了多模态数据（RGB图像、IMU数据、ARKit位姿估计）的同步采集与压缩存储，采用BSON序列化格式确保数据完整性。云端处理平台基于Docker容器构建，支持自动化的数据清洗、标注和RLDS/TFDS格式转换。初步实验表明，该系统每 20 \~ 30s 可采集一组高质量的演示数据，显著优于传统运动捕捉系统的效率。

#figure(rotate(-90deg, image("pic/020.png", height: 50%)), caption: "非灵巧的夹爪运动数据录制工具")

六、复现 Diffusion Policy 原文模型，使用遥操作数据进行微调

我们在单张 4090 上使用 Lora 微调了 Diffusion Policy 模型，使用了以 Quest3 最新收集的遥操作数据，训练了 8 个小时，并编写 inference 代码成功部署在 Franka 机械臂上。
  ], [
#text(font: "SimHei")[存在的问题及解决思路：]

新的遥操作数据收集系统解决了许多传统问题，但仍有一些新的问题：

+ Franka 机械臂部署的新策略执行 pick-and-place 任务时，存在不稳定抖动和停滞现象，即机械臂在执行任务时在空中长时间停留的问题。根据我们对数据的分析，我们认为这可能是是由于 action trunk size 过小，导致过去一段时间的机械臂状态均在同一位置，使得 Policy 误判任务的当前状态。此外，我们还发现了收集数据中的部分不合法数据。事实上，人类收集的演示数据很容易不符合机械臂的合法运行空间，例如超出机械臂运动空间，或超过机械臂运动速度和加速度上限等问题。

+ 观察和动作延迟匹配：在实际部署中，由于来自于数据传输、处理时间或硬件响应速度等方面的延迟，观察和动作执行之间的延迟可能会导致性能下降甚至任务执行失败。应该引入延迟匹配机制来确保动作的同步性。

+ 虽然我们在 iPhone 和 Realsense 上使用了广角镜头，但在某些情况下，视觉跟踪仍可能因运动模糊或缺乏视觉特征而失败，需要进一步改进视觉跟踪算法。例如，在快速移动或低光照条件下，视觉信息可能不够清晰或稳定。 

+ 数据质量和收集难度：Diffusion Policy 需要高质量的演示数据，这在灵巧手操作中尤其困难，因为操作精细且复杂。灵巧手操作涉及多个自由度和复杂的动作序列，这使得高维空间的处理成为一个挑战。虽然 Diffusion Policy 在处理多模态和高维空间方面表现出色，但我们仍需要探索有效的方法来确保稳定的学习过程。

+ 计算效率：Diffusion Policy 的推理速度相对较慢，会引来更大的观察和动作延迟匹配问题。我们需要进一步优化模型的推理速度，以提高实时性能。

=== 解决思路

+ 我们计划在数据收集时使用更大的 action trunk size，增加过去一段时间的机械臂状态信息，以便更好地捕捉到机械臂的运动状态。此外，我们还计划在数据收集时加入对机械臂合法运动空间的约束，并在软件端引入 IK 等算法来过滤不合法数据，实时提示操作者。为了提升收集数据的效率，我们还计划加入语音控制功能和语音提示效果。

+ 融合 IMU 数据和视觉数据，使用 IMU 数据来补充视觉数据的不足。IMU 数据可以提供更高频率的姿态估计，并且在低光照或快速运动的情况下仍然可靠。

+ 观察延迟匹配。在实际机器人系统上，分布式传感器捕获了不同的观察数据流（RGB图像，EE pose，深度图等）。对于每个观察流，我们分别测量它们的延迟。在推理时，我们将所有观察数据与具有最高的延迟的相机数据对齐。具体而言，我们首先将RGB图像数据暂时降低为推理所需的频率（通常为10-20Hz），然后根据其他数据的捕获时间戳进行线性插值，例如本体感知和手指角度或夹爪宽度。

+ 使用相对 EE pose 来表述轨迹和本地感知，提升跨具身性 (cross embodiment) 的能力。相对 EE pose 是指在机器人手臂末端执行器 (EE) 的坐标系下描述的姿态信息，这种表示方式可以更好地适应不同的机器人平台和任务场景。

  ], [
#text(font: "SimHei")[下一阶段的工作计划和研究内容：]

一、完善数据采集装置

实现IMU与视觉数据的紧耦合融合算法，开发基于扩展卡尔曼滤波的传感器融合框架，并设计时间戳同步机制，确保IMU(200Hz+)与视觉数据(30Hz)的精确对齐。针对低光照场景优化融合策略，当视觉SLAM失效时自动切换至IMU主导的运动估计。此外，需要实现基于时间戳的数据插值模块，将高频本体感知数据(如100Hz的关节角度)与低频视觉数据对齐。硬件方面，则需完成可穿戴夹爪指头的力/触觉传感器集成

制定包含15种基本动作元语(approach, grasp, rotate等)的标准操作库，开发自动质量检查工具，实时检测数据异常(如二维码丢失、曝光异常)，实现采集过程的元数据自动记录，包括环境光照等上下文信息。

多设备协同采集：完成双臂iPhone系统的标定验证，建立多视角几何约束，开发手机屏幕二维码自标定程序，支持无标定板的快速部署。

二、数据流水线建设

+ 完善RLDS/TFDS格式转换工具，支持多模态数据的高效存储
+ 实现zarr格式的C++接口优化，提升矩阵数据的存取效率
+ 开发自动化的数据增强模块，特别是针对IMU数据的噪声注入

三. Baseline 改进
+ 在FastUMI中集成IMU补偿模块，提升快速运动下的轨迹预测
+ 为AnySense添加基于相对EE pose的跨平台适配层
+ 设计新的观察延迟补偿网络，在模型内部处理异步传感器数据

四. 实验验证
包括设计跨平台测试场景(桌面操作、物料搬运等)，设计 cross embodiment 的实验验证（手套数据，iPhone 数据训练；部署在夹爪和灵巧手的任务成功率）。
  ]
)
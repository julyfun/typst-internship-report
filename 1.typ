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

#figure(image("image.png", width: 80%))

// 局部作用域
#[
#set text(28pt, font: ("Times New Roman", "Heiti SC"))
#set par(leading: 0.5em)
#align(center, [*综合实践项目报告* \ Practical Project Report])
]

\ \

#[
#import "@preview/cuti:0.2.1": show-cn-fakebold
#set text(16pt)
#show: show-cn-fakebold

#show table.cell: it => {
  if it.x == 0 {
    strong(it)
  } else {
    align(center, it)
  }
}

#set text(
  font: ("Times New Roman", "SongTi SC", "FZKai-Z03S")
)

#table(
  columns: (1fr, 2.5fr),
  inset: 10pt,
  align: horizon,
  stroke: (x, y) => (
    y: if y > 0 and x == 1 { 1pt }
  ),
  [课题名称:], [基于优化的快速、高自由度的机器人运动生成方法],
  [学生姓名:], [信息工程],
  [学生学号:], [521260910018],
  [专业:], [信息工程],
  [指导教师:], [卢策吾],
  [学院 / 系:], [巴黎卓越工程师学院],
)
]

#pagebreak()

#[
#set text(16pt, font: ("Times New Roman", "Songti SC"))
#align(center, [*填表说明*])

#set text(14pt, font: ("Times New Roman", "Songti SC"))
+ 每位学生应在指导教师的指导下认真、实事求是地填写各项内容。文字表达要明确、严谨，语句通顺，条理清晰。外来语要同时用原文和中文表达，第一次出现的缩写词，须注出全称。
+ 要求与研究有关的主要参考文献阅读数量不少于10篇，其中外文资料应占一定比例。
+ 项目报告要求用英语、法语或中文撰写（由指导老师决定）。需满足至少4000中文字（英语/法语按比例折算为16000外文字符）。
+ 请用宋体小四号字体填写，并用A4纸打印，于左侧装订成册。 
+ 该表填写完毕后，须请指导教师审核，并签署意见。
+ 此报告将作为巴黎卓越工程师学院综合实践项目考核材料之一。
]

#set page(

  margin: (
    top: 2.54cm,
    bottom: 2.54cm,
    left: 3.17cm,
  ),
    header: [
    #set text(fill: gray)
    #align(right, [#image("image.png", height: 70%)])
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

#[
  #show table.cell.where(y: 0): set text(weight: 900)

  #table(
    columns: (2fr, 1fr, 1fr, 1fr),
    stroke: 0.75pt,
    table.header[课题名称][课题来源][课题性质][项目编号],
    [基于优化的快速、高自由度的机器人运动生成方法], [预研], [论文], [],
  )
]

// [正文]
== 1. 课题研究目的和意义（含国内外研究现状综述）

遥操作可有效收集数据，可用于机器人模仿学习和强化学习@opentv。现有的遥操作系统大多依赖于特定机械臂，或者无法充分利用不同机械臂的冗余自由度。本项目面向现代策略学习框架，设计通用遥操作接口，可大幅降低遥操作系统在不同硬件间迁移的成本，设计的算法可使机器人臂手运动更平滑，提升收集数据和视觉策略模型或视觉语言策略模型 (VLA)训练的效率.

现有的遥操作系统存在许多问题，主要包括延迟高、末端抖动大、易发生碰撞、难以扩展等。医学手术机器人等精细操作领域对机械臂末端执行器的末端抖动容忍度极低@Tremor，即生理性抖动也可能造成远程操作手术的失败；较高的延迟会导致远程操作者的操作反馈不及时，从而增加了操作者的操作难度和轨迹的连贯度；另外，大部分系统与一个特定的部署环境耦合，无法同时在虚拟环境和现实世界中运行，也难以进行传感器和机械臂硬件的迁移。

=== 相关工作
==== UMI
UMI提供了一个便携、直观、低成本的数据收集和策略学习框架，允许直接将多样化的人类演示转化为有效的视觉运动策略。这一框架特别适用于传统遥操作难以完成的任务，如动态、精确、双手操作和长期视角任务。
硬件无关的数据收集通过通用的手持式夹持器和视觉系统，实现了数据的灵活性和可用性。UMI在策略接口中实现了推理时延匹配和相对轨迹动作表示，确保动作的准确性和时间对齐。同时，UMI学习到的策略具有零次射泛化能力，能够在新环境和对象下执行任务@chi2024universalmanipulationinterfaceinthewild。

==== Ranged IK
实时生成可行的机器人运动需要同时完成多个任务（即运动要求）。这些任务可以具有特定的目标，包含一系列有效的目标/或可接受的目标，并对特定目标赋予较高权重。为了同时满足多个竞争的任务，重要的是要利用具有一系列目标的任务所提供的灵活性。Ranged IK 提出了一种实时运动生成方法，该方法可以在一个统一的框架中适应上述三类任务，并利用具有一系列目标的任务的灵活性来适应其他任务。该任务纳入加权和多目标优化结构中，并使用具有新型损失方法来编码任务的有效范围@wang2023rangedikoptimizationbasedrobotmotion。

== 2. 课题研究内容

本研究旨在开发一套系统流程，实现人体手根姿势到机械臂末端的实时、低延迟迁移，降低生理抖动，保证运动精准无碰撞。我们还计划在不同机器人上探索用遥操作数据微调扩散策略。本系统具备单臂和多臂的灵活性，支持单个机械臂的操作，也可以接收多个传感器的信息，同时控制多个机械臂，实现多地远程协作。此外，本系统各模块独立运行，方便迁移到其他机械臂或传感器硬件平台，同时支持模拟机械臂和真实机械臂的操作。

硬件支持：UR10机械臂，有六自由度，臂展1008mm，控制频率200Hz。

Shadow Hand：24自由度、五指灵巧手，通过绳索驱动移动，大小与人手相似。

臂端传感器同时支持HTC开发的VIVE Tracker和Quest3 VR Headset。

VIVE Tracker包含一个可佩戴在手腕上的追踪器和两个Lighthouse基站。Lighthouse室内定位技术不需要使用摄像头，而是在追踪器上安装多个感光传感器，通过接收基站发射的激光束来计算追踪器的六自由度姿态。VIVE Tracker传感器的测量精度为0.2mm，角度精度为0.1°，采样率为90Hz，定位精度高，但输入频率无法直接满足实时控制要求。

Quest3 VR Headset配备了400MP RGB摄像头和左右两侧的追踪摄像头，中间是深度传感器。其内置算法可以以60hz的频率实时获取手部基本姿态和21个关节（拇指5个关节角度，其他手指16个关节角度）的角度估计值。

=== 低延迟

为了避免碰撞，现有的机械臂遥操作系统大多基于离散运动规划。由于运动规划耗时较长，算法只能以较低的频率规划未来一段时间的连续轨迹（包含多个航点）。即使使用Nvidia GPU加速的CuRobo库 @curobo，轨迹规划也需要50ms以上。基于CPU的轨迹规划甚至可能需要3秒以上，引入了较高的延迟。本文提出了一种基于逆运动学（IK）的在线轨迹规划和插值算法，实现低延迟的连续轨迹规划，使机械臂末端能够实时跟踪人手根部的姿态。虽然运动数据经过TCP和ROS2 Topic多级转发，但信号传输总延迟仍在毫秒级，VIVE Tracker低延迟的姿态捕捉也有助于降低遥操作总延迟。

=== 无碰撞

完全基于IK的运动规划，可能会导致机械臂与自身、与物体（如其他机械臂、桌面）发生碰撞。设备碰撞可能会导致机械臂失控，造成人身伤害和财产损失。本系统包含碰撞检测模块，可以在发出计算出的关节角度指令前，对未来的运动轨迹进行碰撞检测。只有当可能发生碰撞时，才调用基于OMPL的轨迹规划算法，生成无碰撞的路点，同时保证低延迟，避免与环境物体发生碰撞，确保操作人员的安全。

=== 低振动

运动学逆解可能导致关节角度加速极高或不连贯；同时操作者手臂末端的生理抖动也可能传递到机械臂末端，造成机械臂末端明显抖动。在线插值算法的特点可以平滑连接任意数量的路点，减少关节角加速度的突变，避免关键伺服电机过载；同时本算法对传感器的输入噪声进行频域分析，利用 $"SO"(3)$ 空间中的卡尔曼位置滤波和低通滤波插值，降低抖动噪声分量。

#figure(image("pic/016.png"), caption: "项目系统架构")

== 3. 研究方法和研究思路（技术路线）

=== 系统架构

本系统主要由手势检测模块、校准模块、运动规划模块组成，各模块之间通过TCP协议或ROS2 Topic、TF2进行通信，可以部署在不同机器上，释放机器的算力需求。例如本系统的手势检测模块部署在对VIVE Tracker传感器驱动比较友好的Windows 10机器上，而校准模块和运动规划模块部署在更方便部署ROS2框架的Ubuntu 22.04机器上，两台机器通过TCP协议传输数据。

=== 手部姿态检测模块

机械臂遥操作的目标是使机械臂末端姿态与人手根部姿态同步，因此传感器需要捕获人手根部的姿态。我们考虑了使用纯视觉的神经网络方案和使用 HTC VIVE Tracker 的 Lighthouse 室内定位技术方案。

1) MidiaPipe Hands 手部检测器是一种基于 MidiaPipe (用于构建跨平台机器学习解决方案) 的实时设备上的手部跟踪解决方案，该方案可以从单张的 RGB 图像中预测人体的手部骨架，并且可以用于 AR/VR 应用，且不需要专用硬件，例如深度传感器@zhang2020mediapipehandsondevicerealtime。

#figure(image("image copy 5.png", width: 50%), caption: "MidiaPipe 手部跟踪效果") <img5>

尽管该方案可以在普通设备上实时运行，但其延时较大且精确度一般，结果抖动较大，不足以直接作为运动规划的目标点。同时，图像坐标系中的手部关键点难以转换为运动规划所需的手根-相机相对位姿，如果使用 PnP 等算法获取手根位姿，会引入额外误差，并且结果依赖于相机内参，拓展性较差。Hand3D@zimmermann2017learningestimate3dhand 提出了将人手 RGB 图像直接转换为手部姿态的方案，但精度仍有限制，对于机械臂末端的精确运动并不适用。
可穿戴

2) HTC VIVE Tracker设备采用Lighthouse激光室内定位技术，以高频率、低延迟提供毫米级的位置信息和0.1°级的姿态信息。佩戴在手腕上，在0.3m范围内以约0.5Hz的频率来回移动。我们采样多组样本，并对其进行FFT计算，如下图所示。

#figure(image("image copy 3.png", width: 60%), caption: "手部生理震动频谱")

如图所示，0.5Hz处的峰值是固定周期来回摆动引起的较大分量。可以看出，手抖信号没有固定周期，无法通过低通滤波器去除，因此我们使用卡尔曼滤波器来处理位置数据。

卡尔曼滤波可以通过融合观测信号和状态预测来估计干净的信号。在每个时间步骤，卡尔曼滤波器执行两个步骤：预测和更新。预测步骤使用状态转移方程来估计下一时刻的状态，而更新步骤使用观测数据来修正预测的状态。

$
x_k = x_(k - 1) + v_(x (k - 1)) Delta t \
y_k = y_(k - 1) + v_(y (k - 1)) Delta t \
z_k = z_(k - 1) + v_(z (k - 1)) Delta t \
v_(x(k)) = v_(x (k - 1)) space.quad v_(y(k)) = v_(y (k - 1)) space.quad v_(z(k)) = v_(z (k - 1))
$

预测步骤：$k$ 时刻的预测值：

$
x_k^- = F(tilde(x)_(k - 1))
$

其中 $tilde(x)_(k - 1)$ 为上一时刻的最优估计值，转移矩阵：

$
F = mat(
  1, 0, 0, Delta t, 0, 0;
  0, 1, 0, 0, Delta t, 0;
  0, 0, 1, 0, 0, Delta t;
  0, 0, 0, 1, 0, 0;
  0, 0, 0, 0, 1, 0;
  0, 0, 0, 0, 0, 1;
)
$

先验误差协方差矩阵 $P_k^- = F P_(k - 1) F^T + Q$，其中 $Q$ 为过程噪声矩阵。

更新步骤:计算卡尔曼增益 $K = P_k^- H^T (H P_k^- H^T + R)^(-1)$，其中 $R$ 为观测噪声矩阵，$H$ 为观测矩阵，有：

$
H = mat(
  1, 0, 0, 0, 0, 0;
  0, 1, 0, 0, 0, 0;
  0, 0, 1, 0, 0, 0;
)
$

则最优估计值 $tilde(x)_k = x_k^- + K(z_k - H x_k^-)$，其中 $z_k$ 为 $3 times 1$ 的观测向量。

后验误差协方差矩阵 $P_k = (I - K H) P_k^-$。取：

$
Q &= mat(
  0.1, 0, 0, 0, 0, 0;
  0, 0.1, 0, 0, 0, 0;
  0, 0, 0.1, 0, 0, 0;
  0, 0, 0, 100, 0, 0;
  0, 0, 0, 0, 100, 0;
  0, 0, 0, 0, 0, 100;
) \ 
R &= mat(
  50, 0, 0;
  0, 50, 0;
  0, 0, 50;
) 
$

在每次获得 VIVE Tracker 的位置数据后进行预测和更新，从而降低原始观测信号的噪声。经过卡尔曼滤波的位置数据 FFT 如@img4 所示：

#figure(image("image copy 4.png", width: 80%), caption: "经过卡尔曼滤波后的 VIVE Tracker 位置数据（Z 轴）的频谱分析") <img4>

由于卡尔曼滤波器具有预测功能，本系统还可以启动针对位置的预测，在必要时使机械臂在匀速运动过程中的位置与人手保持高度一致。但该功能会导致对加速度的跟随产生较大延迟，从而在输入位置急加速或急减速时发生超出目标位置的位移，因此预测是可选的。姿态抖动方面，我们使用将输入数据的姿态使用 $"SO"(3)$ 群低通滤波器插值实现@affine。位姿的滤波可以提升运动学逆解的稳定性@opentv。

=== 标定模块

标定模块的目标是将 VIVE Tracker 的坐标系与机械臂的基坐标系进行对齐，以便后续运动规划模块能够将人手根部的姿态转换为机械臂末端的姿态。使用者可以将 Tracker 放在特定位置后，通过预定的指令标定四个点，即坐标系原点、x 轴、y 轴和 Tracker 原始数据坐标系到自定义坐标系的旋转矩阵。标定模块会获得 Tracker 原始数据坐标系和自定义坐标系的转换矩阵，从而将手臂末端姿态方便地转换为机械臂末端姿态，并在逆解后传输给运动规划模块。

=== 最优化目标 IK 求解器

我们创新的逆运动学（IK）求解器旨在计算机器人手臂到达特定位置和方向所需的关节角度。以前的解决方案，例如机械臂制造商提供的求解器，通常不透明且容易崩溃，而其他解决方案（如KDL）存在解决方案连续性和关节限制问题。我们的方法允许定制目标，例如避障和最小化关节角度变化。这种灵活性确保机械臂平稳高效地运行，适应各种任务和环境，从而提高其在从工业到精细医疗程序的多个应用中的实用性。

$
q = limits("argmin")_q space f(q) "s.t." space l_i <= q_i <= u_i
$

损失函数: $f(q) = sum_(i = 1)^(k) w_i f_i (q, Omega_i)$

以三种形式的损失函数为例：

$
"帧目标" &: lr(||log("FK"(q, Omega)^or)||) \
"帧差" &: sum_(i = 1)
^(d) w_d lr(|| log("FK"((q_(t - 1), Omega)^(-1)"FK"(q_t, Omega))^or)||) \
"关节角度变化量" &: sum_(i = 1)^(d) w_d (q_(t - 1) - q_t)^2
$

=== 运动生成

运动规划模块会从一个缓冲队列中获取最近的关节角度-关节速度对，并进行在线插值规划。对于某个关节，假设其目标角度为 $x_"tar"$，目标速度为 $v_"tar"$，同样地我们有当前角度 $x_0$ 和当前速度 $v_0$。目标是在任意一个控制帧中速度 $v$、加速度 $a$ 和加加速度 $j$ (jerk) 不超过限制的情况下，尽快使角度和速度到达目标值。为简化问题，我们认为“尽快”指的是在不超过限制的条件下，以尽可能大的速度到达目标，并设到达目标时的加速度为 $0$。设角度目标差 $d = x_"tar" - x_0$，则每个控制帧所在的关节角度和速度构成 $d-v$ 图中的一个点。

由于速度和加速度限制，对于特定的距离 $d$，我们能算出该距离下的使得到目标角度时加速度可能为 $0$ 的最优速度 $v$。设该关节的速度限制为 $v_"max"$，加速度限制 $a_"max"$，不失一般性，考虑 $d, v > 0$ 的情况。对于目标速度为 $v_"tar"$，在最优速度 $v$ 以 $-a_"max"$ 减速，我们有到达时间：

$ Delta t = (v - v_"tar") / a_"max" $

容易得到：

$ d = v_"tar" Delta t + 1 / 2 a_"max" Delta t^2 $

解得 $v$ 与 $d$ 的关系：

$ v = sqrt(v_"tar"^2 + 2 a d) $

将该值与速度限制 $v_"max"$ 取较小值，有 $v = min(v_"max", sqrt(v_"tar"^2 + 2 a d))$，如@img8 所示。

#figure(image("image copy 8.png", width: 60%), caption: [对于距离 $d$ 可以算出该距离下的最优速度]) <img8>

算法如@algo1 所示，其中 $"f"$ 为固定控制帧率。使用该算法获取初步最优速度后，可根据最优速度和当前速度的差得到最优加速度，从而得到最优加加速度 jerk，并根据上一控制帧的速度和加速度可获取当前控制帧的最优加速度、速度和目标关节角度。

#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm

#figure(caption: "获取最优路点算法"
)[
  #set align(left)
  #algorithm({
    import algorithmic: *
    Function("online_intpln_best_v", args: ($x_"0"$, $x_"tar"$, $v_"0"$, $v_"tar"$, $"f"$, $v_"max"$, $a_"max"$), {
      Cmt[Initialize the search range]
      Assign[$"d"$][$x_"tar" - x_"0"$]
      Assign[$"d"_"next control if v unchanged"$][$x_"tar" - ("v"_"0" / "fps" + x_"0")$]
      Assign[$"d"_"half"$][$"d" + "d"_"next control if v unchanged"$]
      State[]
      Assign[$v_"best at half d"$][$"sign"("d"_"half") sqrt(abs(2 "d"_"half" a_"max" + v_"tar"^2))$ limited by $v_"max"$]
      State[]
      If(cond: $"sign"(v_"best at half d") != "sign"("d")$, {
        Return[$"d" times "fps"$]
      })
      Else({
        Return[$v_"best at half d"$]
      })
    })
  }
) 
] <algo1>

#figure(image("image copy 6.png", width: 80%), caption: "姿态解算模块和运动规划模块对缓冲区的读写") <img6>

#figure(image("pic/009.png", width: 65%), caption: "最快运动生成结果，从上至下依次为位移，速度，加速度和急动度")

=== 模仿学习

远程操作允许人类操作员远程控制机器人，从而提供一种通过直接交互收集数据的方法。这些数据对于训练机器学习模型至关重要，尤其是在需要人类直觉和灵巧性的场景中。将远程操作与扩散策略（一种生成机器人行为的新方法）结合使用，可以更有效地从人类演示中学习。@chi2024diffusionpolicyvisuomotorpolicy

#figure(image("pic/015.png", width: 80%), caption: "使用本系统收集机器人运动数据") <img6>

扩散策略利用概率框架根据观察对机器人动作进行建模，从而可以捕获复杂的多模态动作分布。这在机器人操作任务中典型的高维动作空间中尤其有益。通过根据视觉输入和关节状态调整这些策略，机器人可以学习以更高的准确度和可靠性执行需要精细运动技能的任务。

最近的进展表明@black2024pi0visionlanguageactionflowmodel，在一种机械臂上训练的策略可以有效地转移到另一种机械臂上，即使两种机械臂具有不同的物理特性或控制机制。这是通过远程操作的在线校正实现的，在策略执行过程中可以减轻机器人之间的视觉差异。收集人类数据来训练残差策略，以整体方式解决各种模拟与现实之间的差距。

== 4. 计划进度安排

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
      [提升优化算法的效率。], [25/2/21], [待完成],
      [使用新的遥操作系统完成高自由度的、自定义的遥操作任务，收集数据。], [25/3/1], [],
      [应用于机械臂灵巧手 Diffusion Policy Model 的模仿学习。], [25/4/15], [],
      [实验验证从遥操作数据收集到 Pocily Model 完整流程的可行性。], [25/5/15], [],
    )
  )
]

#bibliography("1.yaml", title: "参考文献")

#set text(14pt)

#table(
  columns: 1,
  [
== 课题信息

#table(
  columns: 2,
  stroke: (x: none, y: none),
  inset: 10pt,
  align: horizon,
  [课题性质:], [☐ 设计 #h(1cm) ☒ 论文],
  [课题来源：], [☐ 国家级 #h(0.5cm) ☐ 省部级 #h(0.5cm) ☐ 校级 #h(0.5cm) ☐ 横向 #h(0.5cm) ☒ 预研],
  [项目编号], [#underline(" " * 30)],
  [#align(center)[其他]], [#underline(" " * 30)],
)

#align(right)[指导教师签名：#underline(" " * 12 + "卢策吾" + " " * 12)]
#align(right)[2025 年 2 月 21 日]
#v(0.5cm)
  ], [
== 学院（系）意见
  // [end]

#align(right)[院长（系主任）签名：#underline(" " * 12 + "            " + " " * 12)]
#v(0.5cm)
  ], [
#v(1cm)
#align(right)[学生签名：#underline(" " * 12 + "方俊杰" + " " * 12)]
#v(0.5cm)
  ]
)

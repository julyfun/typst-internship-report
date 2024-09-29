#set text(lang: "zh")
#set page(
  margin: (
    top: 2.54cm,
    bottom: 2.54cm,
    left: 3.17cm,
  ),
  header: [
    #set text(fill: gray)
    #align(center, [*SPEIT 2024 Operational Internship Report*])
    #line(length: 100%)
  ],
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
#align(center, [Operational Internship Report\ *认知实习报告* ])
]

\ \

#[
#import "@preview/cuti:0.2.1": show-cn-fakebold
#set text(14pt)
#show: show-cn-fakebold

#show table.cell: it => {
  if it.x == 0 {
    strong(it)
  } else {
    align(center, underline(it))
  }
}

#set table(stroke: (thickness: 0.5pt, dash: "densely-dashed", paint: gray))

#set text(
  font: ("Times New Roman", "FZKai-Z03S")
)

#table(
  columns: (1fr, 1.5fr),
  inset: 10pt,
  align: horizon,
  [学号 / Student ID],
  [
    521260910018
  ],
  [姓名 / Name], [方俊杰],
  [专业 / Major], [信息工程],
  [实习单位 / Company], [上海舞肌科技有限公司],
  [实习职位 / Position], [软件开发实习生],
  [实习时间 / Duration], [ 2024.6 - 2024.8 ],
  [校内导师 / SPEIT Tutor], [ 吉宏俊 ],
  [企业导师 / Enterprise Tutor ], [ 潘韫哲 ],
)
]

#pagebreak()

#[
#set text(16pt, font: ("Times New Roman", "Heiti SC"))
#align(center, [*摘 要*])
]

La téléopération d'un bras robotique consiste à installer des capteurs sur la main humaine et à transmettre des signaux au bras robotique afin qu'il puisse imiter de manière synchrone les mouvements de la main humaine. La téléopération a été largement étudiée et appliquée ces dernières années dans des domaines tels que la médecine, le sauvetage, l’espace et l’apprentissage automatique. La principale motivation de la téléopération est d'utiliser la réaction humaine, la créativité et la précision de la structure mécanique et du contrôle pour permettre aux systèmes robotiques d'effectuer des tâches complexes. Par exemple, la téléopération peut être utilisée pour contrôler à distance des robots chirurgicaux maître-esclave afin de réduire la fatigue chirurgicale des médecins et d'améliorer la précision chirurgicale. La téléopération joue un rôle important dans la collecte de données pour l'apprentissage par imitation, non seulement en fournissant une manipulation précise et fine (manipulation) ; données et fournir des trajectoires naturelles et fluides pour progresser dans l'apprentissage par renforcement des robots humanoïdes.

Les systèmes d'exploitation à distance existants présentent de nombreux problèmes, notamment une latence élevée, une grande gigue des terminaux, des risques de collisions et des difficultés d'expansion. Les domaines d'opérations de précision tels que les robots chirurgicaux médicaux ont une tolérance extrêmement faible à la gigue des effecteurs terminaux des bras robotiques. La gigue physiologique peut également provoquer l'échec des opérations à distance. Des retards plus élevés entraîneront des retours opérationnels intempestifs de la part des opérateurs à distance, augmentant ainsi la difficulté ; du fonctionnement de l'opérateur et de la cohérence de la trajectoire ; de plus, la plupart des systèmes sont couplés à un environnement de déploiement spécifique et ne peuvent fonctionner à la fois dans l'environnement virtuel et dans le monde réel, et il est également difficile de migrer les capteurs et la robotique matériel de bras.

Cette recherche est basée sur le capteur HTC VIVE Tracker et le bras robotique à six axes Aubo pour fournir une solution de téléopération de bras robotique à faible couplage, à faible latence, à faibles vibrations et hautement évolutive, utilisant le positionnement intérieur laser Lighthouse, l'interpolation en ligne, Des technologies telles que le filtrage et la génération de mouvement résolvent les problèmes mentionnés ci-dessus.

#[#set text(14pt, font: ("Times New Roman", "Heiti SC"))
*关键词:*]
#[#set text(14pt)
système temps réel,
évitement des collisions,
opération à distance]

#pagebreak()

#outline(title: "目录", indent: 1.5em)

#pagebreak()

// [正文设置]
#set page(numbering: "1")
#counter(page).update(1)
#counter(figure).update(1)
#set par(first-line-indent: 2em)
#set heading(numbering: "1.1")

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

// [正文]
= 第一章 绪论

== 引言

机械臂的遥操作 (teleoperation) 指在人手上安装传感器并传输信号给即机械臂，使之同步模仿人手动作。遥操作近年来被广泛研究并应用于医学、救援、太空和机器学习等领域。遥操作的主要动机是利用人的反应力、创造力和机械结构和控制的精确性，使机器人系统执行复杂任务。例如，遥操作可用于远程控制主从式手术机器人，以减少医生的手术疲劳和提高手术精度@Tremor；遥操作在模仿学习的数据收集中扮演了重要角色，不仅提供准确且精细的操纵 (manipulation) 数据，而且提供了自然且流畅的轨迹，以推动人形机器人强化学习领域的进步@opentv。

现有的遥操作系统存在许多问题，主要包括延迟高、末端抖动大、易发生碰撞、难以扩展等。医学手术机器人等精细操作领域对机械臂末端执行器的末端抖动容忍度极低，即生理性抖动也可能造成远程操作手术的失败@Tremor；较高的延迟会导致远程操作者的操作反馈不及时，从而增加了操作者的操作难度和轨迹的连贯度；另外，大部分系统与一个特定的部署环境耦合，无法同时在虚拟环境和现实世界中运行，也难以进行传感器和机械臂硬件的迁移。

本研究基于 HTC VIVE Tracker 传感器和遨博 (Aubo) 六轴机械臂，提供一种低耦合、低延迟、低振动、高拓展的机械臂遥操作解决方案，利用了 Lighthouse 激光室内定位、在线插值、滤波、运动生成等技术，解决了上述提到的问题。


// == 本研究主要内容

// 不知道

// = 第二章 相关工作

// ==

// 不知道

= 第二章 遥操作系统

== 系统概述

本研究旨在开发一个系统流程，实现将人手根部姿态实时、低延迟地迁移至机械臂末端，并减弱生理性抖动，同时保证运动过程中的精确和无碰撞。本系统具备单臂和多臂的灵活性，既支持对单一机械臂进行操作，也可同时接收多个传感器的信息并控制多个机械臂，实现多地远程协作功能。此外，本系统各模块之间独立运行，方便迁移到其他机械臂或传感器硬件平台，并同时支持操作仿真机械臂和现实世界机械臂。

#figure(image("image copy.png", width: 90%), caption: "遥操作系统架构") <sys>

如上图所示，本系统主要由感知硬件、算法和执行器三部分组成。

== 系统硬件

公司配备了多台可供测试的 Aubo I5 型号机械臂，每个机械臂具有六个关节自由度，臂展 1008mm，控制频率为 200Hz。厂商提供了基于 TCP 通信的广播机制，可以 200Hz 频率从控制柜获取机械臂内部信息。我们将两台机械臂以镜像方式安装在同一工作台上，中心距离 1100mm，以模拟多机械臂协作的场景。

手臂末端传感器采用 HTC 公司开发的 VIVE Tracker，包含可佩戴于手腕处的追踪器和两个 Lighthouse 基站。Lighthouse 室内定位技术不需要借助摄像头，而是在追踪器上安装了多个光敏传感器，通过接收基站发射的激光束，计算出追踪器的六自由度姿态。VIVE Tracker 传感器的测量精度为 0.2mm，角度精度为 0.1°，采样率为 90Hz。其拥有较高的定位精度，但输入频率无法直接满足实时控制需求。

== 系统特点

=== 低延迟

为了规避碰撞，现有的机械臂遥操作系统大多基于离散的运动规划，由于运动规划所需的时间较久，算法只能以较低频率规划出未来一段时间的连续轨迹（包含多个路点），即使使用 Nvidia GPU 加速的 CuRobo 库，也需要 50ms 以上进行轨迹规划，基于 CPU 的轨迹规划耗时甚至可能超过 3 秒@curobo，引入了较高延迟。本文通过提出一种基于运动学逆解 (Inverse Kinematics, IK) 的在线轨迹规划和插值算法，实现了低延迟的连续轨迹规划，使机械臂末端能够实时追踪人手根部的姿态。尽管运动数据进行了多级 TCP 和 ROS2 Topic 转发，信号传输的总延迟仍为毫秒级，VIVE Tracker 的低延迟位姿捕获也有助于降低遥操作的总延迟。

=== 无碰撞

完全基于 IK 运动规划可能导致机械臂发生自碰撞和与物体的碰撞（如其他机械臂和桌面）。设备碰撞可能导致机械臂失控，造成人员伤害和物资损失。本系统包含了碰撞检测模块，能对计算得到的关节角度指令发布前，对未来的运动轨迹进行碰撞检测，仅在碰撞可能发生时调用基于 OMPL 的轨迹规划算法生成无碰撞路点，在保障低延迟的同时，规避与环境物体的碰撞，保障操作者的安全。

=== 低振动

在不使用传统轨迹规划算法的情况下，运动学逆解可能导致关节角度的加速度极大或加速度不连贯；同时，操作者手臂末端的生理性抖动也可能传递到机械臂末端，导致机械臂末端的明显抖动。在线插值算法的特性能平滑连接任意多个路点，减弱关节角度加速度的突变，避免关键伺服电机的过载；同时，本算法对传感器的输入噪声进行了频率分析，并采用卡尔曼位置滤波和 $"SO"(3)$ 空间中的低通滤波插值，减弱了抖动噪声成分。

=== 任意机械臂和传感器配置

如 @sys 所示，本系统高度模块化，各模块可以通过 TCP 协议、ROS2 Topic 或 TF2 进行通讯，使用者可以根据机械臂的运动学模型文件和传感器通讯接口，快速迁移到其他硬件平台，并支持多传感器-多机械臂配置。本系统同时支持真机运行和虚拟环境运行。在虚拟环境中，可以便利地调试算法的正确性和安全性。

== 系统架构

本系统主要由手部姿态检测模块、标定模块和运动规划模块组成。各模块之间通过 TCP 协议或 ROS2 Topic 以及 TF2 进行通讯，可以部署在不同机器上，解放机器算力需求。例如，本系统的手部姿态检测模块部署在对 VIVE Tracker 传感器驱动更友好的 Windows 10 机器上，而标定模块和运动规划模块则部署在部署 ROS2 框架更便利的 Ubuntu 22.04 机器上，两台机器通过 TCP 协议传输数据。

=== 手部姿态检测模块

机械臂遥操作的目标是使机械臂末端姿态与人手根部姿态同步，因此传感器需要捕获人手根部的姿态。我们考虑了使用纯视觉的神经网络方案和使用 HTC VIVE Tracker 的 Lighthouse 室内定位技术方案。

1) MidiaPipe Hands 手部检测器

这是一种基于 MidiaPipe (用于构建跨平台机器学习解决方案) 的实时设备上的手部跟踪解决方案，该方案可以从单张的 RGB 图像中预测人体的手部骨架，并且可以用于 AR/VR 应用，且不需要专用硬件，例如深度传感器@zhang2020mediapipehandsondevicerealtime。

#figure(image("image copy 5.png", width: 50%), caption: "MidiaPipe 手部跟踪效果") <img5>

尽管该方案可以在普通设备上实时运行，但其延时较大且精确度一般，结果抖动较大，不足以直接作为运动规划的目标点。同时，图像坐标系中的手部关键点难以转换为运动规划所需的手根-相机相对位姿，如果使用 PnP 等算法获取手根位姿，会引入额外误差，并且结果依赖于相机内参，拓展性较差。Hand3D@zimmermann2017learningestimate3dhand 提出了将人手 RGB 图像直接转换为手部姿态的方案，但精度仍有限制，对于机械臂末端的精确运动并不适用。

2) 可穿戴的 HTC VIVE Tracker 设备

该设备使用 Lighthouse 激光室内定位技术，可提供毫米级和位置信息和 0.1° 级别的姿态信息，频率高，延迟低。将其穿戴于手腕上，并在 0.3m 范围内以 0.5Hz 左右频率来回运动，其捕获到的原始位置数据可视化如@hand 所示。

#figure(image("image copy 2.png", width: 80%), caption: "VIVE Tracker 捕获的原始手腕位置") <hand>

可以看出，VIVE Tracker 给出的位置轨迹较为平滑。本文采样了多组样本并对其计算 FFT，如@img3 所示。

#figure(image("image copy 3.png", width: 80%), caption: "VIVE Tracker 位置数据（Z 轴）的频谱分析") <img3>

如图所示，图中 0.5Hz 峰值处为固定周期来回摆动造成的较大分量。可见人手的抖动信号没有固定周期，无法通过低通滤波器去除，因此我们采用了卡尔曼滤波器对位置数据进行处理。

卡尔曼滤波可以通过融合观测信号的和状态预测来估计干净信号。在每个时间步骤上，卡尔曼滤波执行预测和更新两个步骤。预测步骤使用状态转移方程来估计下一时刻的状态，而更新步骤则使用观测数据来对预测状态进行校正。

建模时，我们对 VIVE Tracker 给出位置数据的 $X, Y, Z$ 轴分别建立为匀速运动模型。我们有状态 $X = [x, y, z, v_x, v_y, v_z]$，有：

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

=== 运动规划

在获得目标位姿后，我们通过机器人 KDL 库中基于 LM 算法的运动学逆解@GINSPEC:2524115 获取对应末端姿态所需的六轴关节角度和关节速度。运动规划模块会从一个缓冲队列中获取最近的关节角度-关节速度对，并进行在线插值规划。对于某个关节，假设其目标角度为 $x_"tar"$，目标速度为 $v_"tar"$，同样地我们有当前角度 $x_0$ 和当前速度 $v_0$。目标是在任意一个控制帧中速度 $v$、加速度 $a$ 和加加速度 $j$ (jerk) 不超过限制的情况下，尽快使角度和速度到达目标值。为简化问题，我们认为“尽快”指的是在不超过限制的条件下，以尽可能大的速度到达目标，并设到达目标时的加速度为 $0$。设角度目标差 $d = x_"tar" - x_0$，则每个控制帧所在的关节角度和速度构成 $d-v$ 图中的一个点。

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

计算出的若干对目标关节角度在透传发布给机械臂之前，将传输给 Moveit2 碰撞检测模块进行自碰撞检测和与物体的碰撞检测。如果发生碰撞，则会调用基于 OMPL 的轨迹规划算法生成若干对无碰撞路点，使机械臂平滑地运动到目标位置。如果触发 OMPL 轨迹规划，机械臂在几百毫秒内非实时地运动到新的目标点。该系统可以在运行时添加新的碰撞体，例如桌面、其他机械臂和操作台上的物体，以适应不同的环境。

= 第三章 实验

== 性能分析

本研究对手部姿态检测模块、标定模块和运动规划模块进行了性能分析。

#set table(stroke: (_, y) => if y == 0 { (bottom: 1pt) })
#show table.cell.where(x: 0): set text(style: "italic")
#show table.cell.where(y: 0, x: 0): set text(style: "normal", weight: 900)
#figure(
table(
  columns: 4,
  align: center + horizon,
  inset: (y: 0.8em),
  table.header[硬件 / 模块 / 耗时 (ms)][HTC Vive Tracker][Windows 10 \ i7-13790F \ RTX 2060 SUPER][WSL 2 \ Ubuntu 22.04 \ i7-13790F],
  [Lighthouse 定位], [$< 30$], [/], [/],
  [标定模块 TF 通信延迟], [/], [/], [$< 0.001$],
  [TCP 通信延迟], [/], [$< 1$], [$< 1$],
  [OMPL 轨迹规划], [/], [/], [$120 plus.minus 20$],
  [在线插值规划], [/], [/], [$< 1$],
  [碰撞检测], [/], [/], [$0.6 plus.minus 0.1$],
  [机械臂路点缓存], [/], [/], [$90 plus.minus 30$],
)
)

// Table as seen above

== 真机实验

本章节将展示本系统在真机执行不同任务的表现，执行机械臂型号为 Aubo I5 机型。

#figure(image("image copy 11.jpg", width: 60%), caption: "手持 VIVE Tracker 控制单一机械臂的位姿") <i11>

如@i11 所示，手持 VIVE Tracker 可对单一机械臂进行末端位姿控制。该任务考验机械臂能否对高速运动或摆动的手臂能否快速准确跟踪，以及碰撞规避和安全性功能。机械臂末端能够实时追踪人手根部的姿态，执行延迟介于 100ms 到 150ms 之间。

#figure(image("image copy 12.png", width: 60%), caption: "穿戴 VIVE Tracker 控制两台机械臂的位姿") <i12>

如@i12 所示，穿戴一台 / 两台 VIVE Tracker 可同时控制两台机械臂的末端位姿。该任务主要考验系统的扩展性、算法延迟的稳定性和两台机械臂合作时的安全性。

#figure(image("image copy 15.png", width: 60%), caption: "穿戴 VIVE Tracker 控制两台机械臂的位姿") <i15>

如@i15 所示，该任务将圆珠笔固定于机械臂末端法兰盘，并穿戴 VIVE Tracker 控制机械臂远程控制圆珠笔在纸上绘制图案。该任务考验了遥操作系统的精度、末端稳定性和易用程度。该任务还将盛水的矿泉水瓶固定在机械臂末端，以放大观察机械臂末端的抖动情况。

#figure(
table(
  columns: (1fr, 0.8fr, 1fr, 2fr),
  align: center + horizon,
  inset: (y: 0.8em),
  table.header[任务][所用系统][所需能力][执行结果],
  [手持控制], [单传感器-单臂], [末端稳定，执行安全，碰撞规避，快速跟踪], [振动肉眼不可见；跟随的运动频率上限为 $1.5 plus.minus 0.5$Hz，跟随总延迟为 $120 plus.minus 20$ms，轨迹平滑，任意关节速度均不超过 $150degree slash s$。任何条件下，机械臂均不会与桌面发生碰撞。],
  [穿戴控制双臂], [单/多传感器-双臂], [稳定延迟，多臂安全，高扩展性], [双臂轨迹平滑，无碰撞，可模拟人类双臂合作任务],
  [写字], [单传感器-单臂], [精确移动，末端稳定，易用], [操作着经过 3 至 4 次热身适应，可在 2 至 3s 内画出简单的图形，圆珠笔末端轨迹稳定],
  [拿水瓶], [单传感器-单臂], [末端稳定，移动稳定], [手根静止和移动情况下，水面振动与人手持类似],
)
)

== 总结

机械臂末端仅有肉眼不可见的轻微振动。当以人手最快速度大于 2Hz 的频率做 0.3m 的往复运动时，机械臂开始出现无法跟随的情况，这主要是由该型号机械臂的加速度限制所致。当手臂以 1Hz 高速运动时，机械臂能快速跟随，轨迹平滑，任意关节速度均不超过给定的 $150degree slash s$。本系统对末端稳定性的优化使得机械臂手持物体不会受到人手自然抖动的明显影响，使得机械臂能以一定精度完成写字、传递物品等日常任务。任何条件下，包括手根放在过低位置或延伸过长时，机械臂均不会与桌面发生碰撞。

由于六轴机械臂的奇异点问题，在某些位姿下，末端位姿的微小运动需要剧烈的关节角度转动才能实现。本系统会检测逆解发生剧烈改变的情况，并在这种情况下进一步限制关节速度，保证了遥操作过程的安全性。

= 第四章 全文总结

== 结论

本系统构建了一套基于机器人逆运动学、在线插补算法和碰撞检测的实时机械臂遥操作系统，通过其低延迟特性，为操作者与机械臂自然、直观的交互提供了可能性，实验结果表明，本系统使得人手和机械臂末端到达目标位置的延迟仅为 $120 plus.minus 20$ms，优于基于离散轨迹规划的算法@curobo，且延迟浮动较小，使得双臂协作任务更加直观高效。传统上，机器人操作需通过编程指定精确地动作轨迹，而该遥操作系统可在操作时执行更灵活复杂的任务，并为机器人模仿学习提供了自然且平滑的轨迹样本。通过引入碰撞检测算法，本系统可以动态地添加碰撞体，在快速追踪的同时保证了运动的无碰撞，从而适应不同环境，在快速跟踪的同时保证了操作者和机械臂的安全性。同时，算法对传感器的观测数据进行了滤波优化，而在线插补算法自然地限制了机械臂关节运动的速度、加速度和加加速度，使得机械臂末端的运动更加平滑，减少了关节电机过载和末端超调振动的风险，使得本系统更适用于手术机器人等对运动稳定性极为敏感的领域。

本系统模块之间低耦合，接口明确，使用者无需修改大量代码就可以在不同的部署环境之间快速迁移，其灵活的配置文件允许用户轻松适配不同的传感器、机器人和末端执行器，降低了用户的使用成本，实现了高度的可定制化，使本遥操作系统成为适应各种复杂环境和任务的理想选择。

== 局限

// 尺寸和 奇异点，抖动问题，延迟饥饿问题，延迟规划问题，无法追踪加速度，超调
// 视觉反馈
//

本系统的目标是以尽可能低的延迟将人手根姿态消除生理性抖动后，无碰撞地迁移到机械臂末端，然而当前方案仍有改进空间。例如，可以引入 RGB-D 相机或 Quest3 等 VR 头显设备检测人手姿态，扩大操作者的灵活运动空间，并提供遥操作手指动作的可能性。此外由于机械臂和人手臂的尺寸不同，且不同的操作者的肩宽、手臂长度也存在天然的差异，给机械臂的动作空间带来了更多要求，例如当前算法下，当人手双臂贴合时，机械双臂可能相距较远或者因为解碰撞而相互避让。较为简单的解决方法是引入手臂尺寸放缩参数，并将操作者的肩宽考虑在内。

操作者使用本系统完成写字等任务时，需要侧身观察机械臂末端的实际位置，以进行闭环调整，操作者往往因为无法同时顾及自身手腕位置和机械臂末端位置而难以流畅操作。该问题同样可以通过引入视觉反馈解决，例如在双臂之间的位置安装摄像头，将实时图像传回操作者的 VR 头显中，使得操作者可以直观地看到机械臂末端的位置，实现如同手臂即机械臂一般的体验。

本系统的多级通信引入了一定延迟，传感器和机械臂的执行延迟难以完全消除，但影响较小。本系统主要可优化的延迟为机械臂的路点缓存，由于 Aubo I5 机械臂防止饥饿的特性，算法必须获得机械臂的路点缓存并发送足够的路点将其填充到指定大小。该步骤不可避免地引入了较大延迟，即发送的数据必须等到其之前的缓存消耗完后才能执行。目前可以通过降低缓存大小缓解延迟问题，但会带来一定不稳定性。未来可以考虑引入动作预测算法，并提高控制频率来减小延迟。

== 未来工作

本系统可用于模仿人手动作，并生产机器人模仿学习的天然数据，这种数据可以使机器人在不断实践中提升自己的表现，让机器人控制更加自主和智能。本系统未来将用于适配舞肌科技的新型灵巧手，以实现更加精细的手部动作迁移。

未来工作将进一步优化系统的延迟，并着重提升操作者的感官反馈，除了引入 VR 头显外，还将在灵巧手和机械臂上安装触觉传感器，并通过振动等方式将触觉信息反馈给操作者，使得操作者能够更加直观地感知机械臂末端的位置和力度。与此同时，可以开发更智能的控制算法，理解操作者的手部移动和获取物体等意图，并通过强化学习算法使得机械臂自主完成抓取等动作，从而减轻操作者的负担，为机器人在不同任务中的应用提供广阔的发展空间。

#bibliography("1.yaml", title: "参考文献")

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

#[#set text(14pt, font: ("Times New Roman", "Heiti SC"))
*关键词:*]
#[#set text(14pt)
实时，无碰撞，遥操作]

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

机械臂的遥操作 (teleoperation) 指在人手上安装传感器并传输信号给即机械臂，使之同步模仿人手动作。遥操作近年来被广泛研究并应用于医学、救援、太空和机器学习等领域。遥操作的主要动机是利用人的反应力、创造力和机械结构和控制的精确性，使机器人系统执行复杂任务。例如，遥操作可用于远程控制主从式手术机器人，以减少医生的手术疲劳和提高手术精度@Tremor；遥操作在模仿学习的数据收集中也扮演重要角色，不仅提供准确且精细的操纵 (manipulation) 数据，而且提供了自然且流畅的轨迹，以推动人形机器人强化学习领域的进步。

现有的遥操作系统存在许多问题，主要包括延迟高、末端抖动大、易发生碰撞、难以扩展等。医学手术机器人等精细操作领域对机械臂末端执行器的末端抖动容忍度极低，即生理性抖动也可能造成远程操作手术的失败@Tremor；较高的延迟会导致远程操作者的操作反馈不及时，从而增加了操作者的操作难度和轨迹的连贯度；另外，大部分系统与一个特定的部署环境耦合，无法同时在虚拟环境和现实世界中运行，也难以进行传感器和机械臂硬件的迁移。

本研究基于 HTC VIVE Tracker 传感器和遨博 (Aubo) 六轴机械臂，提供一种低耦合、低延迟、低振动、高拓展的机械臂遥操作解决方案，利用了 Lighthouse 激光室内定位、在线插值、滤波、运动生成等技术，解决了上述提到的问题。


== 本研究主要内容

不知道

= 第二章 相关工作

==

不知道

= 第三章 遥操作系统

== 系统概述

本研究旨在开发一个系统流程，实现将人手根部姿态实时、低延迟地迁移至机械臂末端，并减弱生理性抖动，同时保证运动过程中的精确和无碰撞。本系统具备单臂和多臂的灵活性，既支持对单一机械臂进行操作，也可同时接收多个传感器的信息并控制多个机械臂，实现多地远程协作功能。此外，本系统各模块之间独立运行，方便迁移到其他机械臂或传感器硬件平台，并同时支持操作仿真机械臂和现实世界机械臂。

#figure(image("image copy.png", width: 80%), caption: "遥操作系统架构") <sys>

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

本系统主要由手部姿态检测模块、标定模块和运动规划模块组成。各模块之间通过 TCP 协议或 ROS2 Topic 以及 TF2 进行通讯，可以部署在不同机器上，解放机器算力需求。例如，本系统的手部姿态检测模块部署在对 VIVE Tracker 传感器驱动更友好的 Windows 10 机器上，而标定模块和运动规划模块则部署在部署 ROS2 框架更便利的 Ubuntu 22.04 机器上，两台机器通过 TCP 协议单向传输数据。

=== 手部姿态检测模块

机械臂遥操作的目标是使机械臂末端姿态与人手根部姿态同步，因此传感器需要捕获人手根部的姿态。我们考虑了使用纯视觉的神经网络方案和使用 HTC VIVE Tracker 的 Lighthouse 室内定位技术方案。

1) MidiaPipe Hands 手部检测器

这是一种基于 MidiaPipe (用于构建跨平台机器学习解决方案) 的实时设备上的手部跟踪解决方案，该方案可以从单张的 RGB 图像中预测人体的手部骨架，并且可以用于 AR/VR 应用，且不需要专用硬件，例如深度传感器@zhang2020mediapipehandsondevicerealtime。

#figure(image("image copy 5.png", width: 50%), caption: "MidiaPipe 手部跟踪效果") <img5>

尽管该方案可以在普通设备上实时运行，但其延时较大且精确度一般，结果抖动较大，不足以直接作为运动规划的目标点。同时，图像坐标系中的手部关键点难以转换为运动规划所需的手根-相机相对位姿，如果使用 PnP 等算法获取手根位姿，会引入额外误差，并且结果依赖于相机内参，拓展性较差。xxx2.5D 和 hand3d 提出了将人手 RGB 图像直接转换为手部姿态的方案，但精度仍有限制，对于机械臂末端的精确运动并不适用。

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

= 第四章 实验


#bibliography("1.yaml", title: "参考文献")

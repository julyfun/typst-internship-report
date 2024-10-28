#import "@preview/touying:0.4.2": *
#import "@preview/cetz:0.2.2"
#import "@preview/ctheorems:1.1.2": *
#import "@preview/fletcher:0.5.0" as fletcher: diagram, node, edge, shapes

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

// Register university theme
// You can replace it with other themes and it can still work normally
#let s = themes.university.register(aspect-ratio: "16-9")

// Set the numbering of section and subsection
#let s = (s.methods.numbering)(self: s, section: "1.", "1.1")

// Set the speaker notes configuration
// #let s = (s.methods.show-notes-on-second-screen)(self: s, right)

// [my]

#set text(
  font: ("New Computer Modern", "Songti SC")
)
#show strong: set text(weight: 900)  // Songti SC 700 不够粗

// Global information configuration
#let s = (s.methods.info)(
  self: s,
  title: [Internship report in UJI],
  subtitle: [Works in robot arm teleoperation],
  author: [Junjie Fang],
  date: datetime.today(),
  institution: [SJTU],
)

// Pdfpc configuration
// typst query --root . ./example.typ --field value --one "<pdfpc-file>" > ./example.pdfpc
#let s = (s.methods.append-preamble)(self: s, pdfpc.config(
  duration-minutes: 30,
  start-time: datetime(hour: 14, minute: 10, second: 0),
  end-time: datetime(hour: 14, minute: 40, second: 0),
  last-minutes: 5,
  note-font-size: 12,
  disable-markdown: false,
  default-transition: (
    type: "push",
    duration-seconds: 2,
    angle: ltr,
    alignment: "vertical",
    direction: "inward",
  ),
))

// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

// Extract methods
#let (init, slides, touying-outline, alert, speaker-note) = utils.methods(s)
#show: init

#show strong: alert

// Extract slide functions
#let (slide, empty-slide) = utils.slides(s)

#show raw.where(lang: "cpp"): it => {
  set text(12pt)
  it
}

#set text(20pt)
#set list(indent: 0.8em)

// #set figure(supplement: none)

#show: slides

// --- 以下为正文


== Background - Teleoperation

- Detect human hand posture and let the robot arm mimic it
- As accurate, fast, smooth and safe as possible
- The startup company is designing a new type of Dexterous Hand and it will be installed on the robot arm

#figure(image("pic/002.jpg", height: 56%), caption: "Aubo I5 arm")

== What can it be used for?

- Medicine
- Rescure
- Space
- Robot imitation learning
- Remote job in milk tea shop (The CEO's idea)

#figure(image("pic/004.png", height: 55%))

#let cap1 = "Hand posture detection - Kalman filter smoothing"

== #cap1

#slide[
#figure(image("pic/005.png", height: 55%), caption: "HTC VIVE Tracker")
][
#figure(image("image copy 2.png", height: 55%), caption: "Movement capture")
The sensor captures posture with high accuracy (translation and rotation) - but physiological vibration still exists!
]

== #cap1

#slide[
#figure(image("image copy 3.png", height: 55%), caption: "Vibration frequencies")
It can be seen that hand vibration signals has no fixed period and cannot be removed by a simple low-pass filter. 
][
#[
#set text(14pt)
$
F = mat(
  1, 0, 0, Delta t, 0, 0;
  0, 1, 0, 0, Delta t, 0;
  0, 0, 1, 0, 0, Delta t;
  0, 0, 0, 1, 0, 0;
  0, 0, 0, 0, 1, 0;
  0, 0, 0, 0, 0, 1;
) \
P_k^- = F P_(k - 1) F^T + Q \
K = P_k^- H^T (H P_k^- H^T + R)^(-1) \
H = mat(
  1, 0, 0, 0, 0, 0;
  0, 1, 0, 0, 0, 0;
  0, 0, 1, 0, 0, 0;
) \
tilde(x)_k = x_k^- + K(z_k - H x_k^-) \
P_k = (I - K H) P_k^-
$
]

So we build a movement equation for hand posture and use Kalman filter to smooth the movement.
]

== #cap1

#figure(image("image copy 4.png", height: 75%), caption: "Kalman filter significantly reduces vibration \n (blue: original, orange: filtered)")

#let cap2 = "New IK solver - Customize objectives"

== #cap2

- Inverse Kinematics: Solve the joint angles for the robot arm to reach the target position and rotation
- Prior works:
  - Internal solver provided by the robot arm manufacturer 
    - Non-transparent
    - Sometimes crashes
  - KDL:
    - Large gaps between solutions in consecutive updates
    - No joint angles and limits
- Numerous objectives:
  - Reach the target
  - Avoid obstacles
  - Small joint angle gaps
  - Make full use of all DOFs
  
== #cap2

- Cast the standard IK formulation to a non-linear optimiztion problem!

$
q = limits("argmin")_q space f(q) "s.t." space l_i <= q_i <= u_i
$

Loss function: $f(q) = sum_(i = 1)^(k) w_i f_i (q, Omega_i)$

In 3 forms or more:

$
"frame target" &: lr(||log("FK"(q, Omega)^or)||) \
"frame del" &: sum_(i = 1)
^(d) w_d lr(|| log("FK"((q_(t - 1), Omega)^(-1)"FK"(q_t, Omega))^or)||) \
"joint del" &: sum_(i = 1)^(d) w_d (q_(t - 1) - q_t)^2
$

Achiece the target with minimal joint angle changes.

== #cap2

- A general purpose IK solver with customizable loss function terms.
  - Easily design loss terms for different tasks and arms!
- To handle bound constraints and for convergence efficiency, We optimize the loss function using L-BFGS-B method.

#let cap3 = "Online interpolation - Fast and smooth movement"

== #cap3

- Output of the IK solver cannot be directly used by the robot arm!
  - Frequency problem
    - Sensor frequency $!=$ Control frequency
  - Acceleration and jerk limits
    - Motor current $<==>$ Acceleration
    - Current change rate $<==>$ Jerk
- Calculate the joint angle and joint velocity target each time the IK result updates
- Achieve the target angle and velocity as fast as possible - Is there a best trajectory?

== #cap3

#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm

#figure(caption: "The online interpolation algorithm"
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

== #cap3

- Advantages to prior interpolation methods:
  - No need to provide expected time
  - Will never exceed the acceleration and jerk limits
  
#figure(image("pic/007.png", height: 65%), caption: "Control the arm to draw shapes")
  
== Extensible teleoperation system

- The framework is fully object-oriented and extensible 
- Virtual environments
- Dual arm and other sensors

#figure(image("pic/006.png", height: 100%))

== Code

The code can be found in https://github.com/julyfun/moveit2_aubo

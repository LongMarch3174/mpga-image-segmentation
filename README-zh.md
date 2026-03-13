# MPGA 图像分割

这是一个基于 MATLAB 的图像分割项目，核心流程包括：

- **频域预处理**（低通滤波）
- **大津法（OTSU）目标函数**
- **多种群遗传算法（MPGA）** 自适应搜索最优分割阈值

仓库中也提供了一个固定阈值的基线脚本用于对比。

## 功能特性

- 将输入图像转换为灰度图。
- 在频域中进行低通滤波，抑制高频噪声。
- 使用 MPGA 搜索最优二值化阈值。
- 输出 **PNG** 和 **EMF** 两种格式的分割结果。
- 绘制并导出进化过程曲线。

## 仓库结构

- `mpga.m`：完整流程（预处理 -> MPGA 优化 -> 图像分割）。
- `main.m`：固定阈值（`102`）的基线分割脚本。
- `pre.m`：独立预处理脚本。
- `OTSU.m`：大津法类间方差目标函数。
- `immigrant.m`：种群间移民算子。
- `EliteInduvidual.m`：精英保留 / 人工选择算子。

## 输入与输出文件

### 输入

- `sample.png`：脚本使用的源图像。

### 输出

- `gray_sample.png`：灰度图。
- `preprocessed_sample.png`：用于阈值搜索的滤波结果。
- `evolution_process.emf`：进化过程曲线图。
- `segmented_image.png`：最终二值分割图。
- `segmented_image.emf`：最终分割图的 EMF 导出文件。

## 运行环境

- MATLAB（建议 R2018 及以上）。
- Image Processing Toolbox（`imread`、`imwrite`、`imhist`、`imshow` 等函数）。
- `mpga.m` 依赖的遗传算法函数：
  - `crtbp`、`bs2rv`、`ranking`、`select`、`recombin`、`mut`、`reins`

> 如果当前 MATLAB 环境中没有上述 GA 函数，请安装兼容的遗传算法工具箱（例如 GEATbx 风格接口），或替换为 MATLAB 内置遗传算法等价实现。

## 快速开始

1. 将测试图像放在项目根目录，并命名为 `sample.png`（或修改脚本中的路径）。
2. 运行完整 MPGA 流程：

```matlab
mpga
```

3. 在项目根目录查看生成结果。

## 基线方法（固定阈值）

运行以下命令可执行固定阈值版本：

```matlab
main
```

该脚本会按阈值 `102` 直接进行二值化，并导出 `segmented_image.emf`。

## 说明

- `OTSU.m` 会读取 `preprocessed_sample.png`，因此建议先执行预处理（或直接运行已包含预处理流程的 `mpga.m`）。
- 当前脚本默认灰度范围为 `[0, 255]`。
- 可在 `mpga.m` 中调整 MPGA 参数（如种群规模、交叉/变异概率、迭代代数）以适配不同图像。

## 许可证

本项目使用 [LICENSE](LICENSE) 中定义的许可条款。

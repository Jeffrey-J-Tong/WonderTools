# How to use SpikeInterface

1. SpikeInterface是一个积极开发中的项目, 新的版本可能会有依赖和API的变更, 此指南也应及时翻新

   经过验证可以正常使用的SI版本:

   - 0.101(.2)
   - 0.102

2. 一些会用到的工具

   - SpikeInterface中的example有些是.py格式, 但是本质是通过jupytext插件将.ipynb改成了.py格式, 需要`pip install jupytext`之后右键open with notebook打开 (如果在vscode中使用, 需要安装`Jupytext for Notebooks`, 之后可以以notebook格式打开.py文件)

   - 要下载[G-Node GIN](https://gin.g-node.org/)平台上托管的数据, 需要`pooch`, `datalad`两个包, 其中`datalad`包的安装比较特殊(管理员权限运行anaconda):

     ```bash
     pip install datalad-installer
     datalad-installer git-annex -m datalad/packages
     pip install datalad
     ```

3. 本指南主要参考:

   - [GitHub 库](https://github.com/SpikeInterface/spikeinterface)中的[quickstart.py](https://github.com/SpikeInterface/spikeinterface/tree/main/examples/get_started)

   - [SpikeInterface tutorial](https://spikeinterface.readthedocs.io/en/stable/)
   - [ProbeInterface tutorial](https://probeinterface.readthedocs.io/en/main/index.html)

## 安装

### 安装SpikeInterface本体

安装前可以去[pypi 官网](https://pypi.org/project/spikeinterface/0.102.0/)看一下SpikeInterface依赖的python版本

```bash
conda create -n si python==3.9
conda activate si
pip install "spikeinterface[full,widgets]"
```

(还有在vscode中运行.ipynb文件需要的ipykernel)

### 在docker中安装sorters

如何安装docker请自行百度

spikeinterface可以使用[docker hub](https://hub.docker.com/u/spikeinterface)中的镜像来直接搞定各种sorter, 甚至可以通过这种方法避免配置MATLAB和cuda等繁琐的工具

### 安装phy2

1. 如果网络状况OK(国内可能都不太OK, 要给anaconda环境中的git配置网络)

   直接下载一个`environment.yml`文件, 然后执行

   ```bash
   conda env create -f /path/to/environment.yml
   ```

2. 如果网络状况不OK(至少得搞定conda换源+能连上GitHub)

   1. 从GitHub下载phy2的文件

   2. 把environment.yml里最后两行关于pip的内容删掉, **另存**为一个文件`env.yml`

   3. 在anaconda中执行以下命令

      ```bash
      cd /path/to/phy2
      conda env create -f env.yml
      conda activate phy2
      pip install .
      ```

### 安装CUDA和NVIDIA Container Toolkit



## 使用

### 1. 加载数据

配置 probe: 使用 `probeinterface`

probeinterface 可以通过制造商和型号直接获取电极排布, 并且可以定义硅电极和记录系统的连接方式

还可以画出 probe 的二维或三维结构

`widgets` 模块可以像 NeuroScope 一样展示记录数据

### 2. 预处理

1. 先做 滤波
2. 再做 CMR (common reference) **(???????)**

### 3. 保存 SI 对象

SI 中如滤波等功能并不会马上执行, 需要将 SI 对象保存

```python
n_cpus = os.cpu_count()
n_jobs = n_cpus - 4
job_kwargs = dict(n_jobs=n_jobs, chunk_duration="1s", progress_bar=True)
# kwargs: keyword arguments
if (base_folder / "preprocessed").is_dir():
    recording_saved = si.load_extractor(base_folder / "preprocessed")
else:
    recording_saved = recording_sub.save(folder=base_folder / "preprocessed", **job_kwargs)
```

`.raw` 文件中保存**处理后的** raw data, `.json` 文件保存文件相关的信息, `probe.json` 保存电极信息

**这一保存方法同样适用于所有的 `Sorting` 对象**

### 4. 数据压缩

数据压缩需要 `numcodecs` 模块

```python
import numcodecs
    compressor = numcodecs.Blosc(cname="zstd", clevel=9, shuffle=numcodecs.Blosc.BITSHUFFLE)
    recording_saved = recording_sub.save(format="zarr", folder=base_folder / "preprocessed_compressed.zarr",
                                         compressor=compressor,
                                         **job_kwargs)  # ** 将字典中的键值对解包成关键字参数, 从而传递给函数
```

### 5. Spike Sorting

建议的sorter (GPT的建议):

- 对于tetrode数据: kilosort 2
- 对于硅电极数据: MountainSort 4 or 5, Klusta

si 支持的 sorting 方式:

1. (x) 调用外部 sorter
   - 过程中涉及到使用 shell 脚本与其他程序进行交互, 目前在 linux 和 macOS 上多数 shell 都 work, 但是在 windows 上需要将默认 shell 指定为 CMD
   - 配置外部 sorter 简直就是折磨王
2. (x) 使用专为 si 开发的 internal sorter 工具
   - 包括 spykingcircus2 和 tridesclous2
   - 处于开发初期, 且并未被广泛使用
3. 直接使用 SpikeInterface 官方做好的 docker 镜像
   - 使用这种方法甚至不需要 MATLAB 来运行 KiloSort
   - `pip install docker`

```python
si.available_sorters()  # 可用的 sorting 工具
si.installed_sorters()  # 已经安装的 sorting 工具
```

在容器中运行 sorter, 需要:

1. 安装 docker / singularity
2. 安装对应的 python SDK `pip install docker/spython`
3. 为了使用 GPU 加速, 需要安装 CUDA 和 [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) ([说明](https://spikeinterface.readthedocs.io/en/0.95.0/containerized_sorters.html))

在 docker 中只需要安装镜像即可, 不需要创建对应的容器, 在运行脚本过程中会自动创建

01/24/2025: 未使用 GPU 加速情况下 demo 数据运行 KS 耗时 2m 37.9s

### 6. 提取波形

`extract_waveforms()` 和 `WaveformExtractor()` 应当使用 `SortingAnalyzer` 替代

1. `get_waveforms`

   waveform 矩阵的大小为 (num_spikes, num_samples, num_channels)

   默认最多提取 500 个 spike 的波形

2. `get_templates`

   template 矩阵的大小为 (num_samples, num_channels)

Sparsity

==没搞懂 sparsity 是什么意思==

但是 `compute_sparsity` 可以找到每个神经元波形分布的通道

==没搞懂 sparse waveform 是什么意思==

经过 sparsity 这一步的处理之后, 波形矩阵中的第三个维度被大幅缩小了 (从49个通道缩小到14个通道)

### 7. 后处理

自 0.101.0 版本后 API 有所改变, 引入了 `SortingAnalyzer`

后处理的内容和对应的参数参考[此处](https://spikeinterface.readthedocs.io/en/latest/modules/postprocessing.html)

后处理的内容包括: spike 幅值, PCA score, 波形特征, 模板相似性, 互相关

1. PCA score

   `si.compute_principal_components`

2. spike amplitude

   `si.compute_spike_amplitude`

3. unit and spike locations

4. correlograms

5. template similarity

大部分后处理的函数都需要 `SortingAnalyzer` 对象作为输入 (在 0.101 版本之前使用的是 `WaveformExtractor`, 这个类在新版本中已经被弃用, 详细对比见 [From WaveformExtractor to SortingAnalyzer](https://spikeinterface.readthedocs.io/en/stable/tutorials/waveform_extractor_to_sorting_analyzer.html#from-waveformextractor-to-sortinganalyzer)):

1. `SortingAnalyzer` 属于 `postprocessing` 模块
2. `SortingAnalyzer` 对象可以被理解为 recording 和 sorting 的结合. 因此 `analyzer` 中包含了 `recording` 和 `sorting` 的全部信息, 和一些其他信息, 都可以从中读出
3. 后处理的许多内容都是 `SortingAnalyzer` 对象的 extension
4. 在保存 `SortingAnalyzer` 后, 基于其进行的计算结果都会一并保存

### 8. Quality matrics

用于???, 包括???

Quality matrics 也是 `SortingAnalyzer` 的 extension. 现在有统一的 `SortingAnalyzer.compute` 函数用于计算所有参数, 但是旧的 `WaveformExtractor` 的函数也可以用于 `SortingAnalyzer`

单独计算

```python
amp_cutoff = analyzer.compute(
    "quality_metrics",
    metric_names=["amplitude_cutoff"]
)
amp_cut_data = amp_cutoff.get_data()
#or: compute_amplitude_cutoff(analyzer)
```

全部计算

```python
dqm_params = si.get_default_qm_params()
amp_cutoff = analyzer.compute(
    "quality_metrics",
    qm_params=dqm_params
)
#alt: compute_quality_metrics(analyzer)
```


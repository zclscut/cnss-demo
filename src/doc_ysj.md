## A律量化的文档

#### 量化编码

`pcm_code = quantization(signal)`

- input: `signal` 是抽样信号 (一个 double 类型的数组)
- output: `pcm_code` 是量化编码 (用十进制的 double 表示) (数组形状和 `signal` 一致)

#### 解调

`signal = dquantization(pcm_code)`


Hello,

I am writing to report a potential Regular Expression Denial of Service (ReDoS) vulnerability or Inefficient Regular Expression in the project. When using specially crafted input strings in the context, it may lead to extremely high CPU usage, application freezing, or denial of service attacks.

**Location of Issue:**

The vulnerability is related to a regular expression used in the following validation file, which may result in significantly prolonged execution times under certain conditions.

https://github.com/webpack/webpack/blob/001cab14692eb9a833c6b56709edbab547e291a1/lib/util/semver.js#L221

https://github.com/webpack/webpack/blob/001cab14692eb9a833c6b56709edbab547e291a1/examples/build-http/webpack.lock.data/https_cdn.skypack.dev/aggregate-error_v4.0.0-rCH8s5R9g4kQQ807o58j_dist_es2020_mode_imports_optimized_aggregate-error_12f7879e59421c0b09bf.js#L25

https://github.com/webpack/webpack/blob/001cab14692eb9a833c6b56709edbab547e291a1/examples/build-http/webpack.lock.data/https_cdn.esm.sh/v53_aggregate-error_4.0.0_es2015_aggregate-error_ff6bcc1ba33bf3b1810a.js#L2

https://github.com/webpack/webpack/blob/001cab14692eb9a833c6b56709edbab547e291a1/lib/util/conventions.js#L54

https://github.com/webpack/webpack/blob/001cab14692eb9a833c6b56709edbab547e291a1/lib/MultiCompiler.js#L165

https://github.com/webpack/webpack/blob/001cab14692eb9a833c6b56709edbab547e291a1/lib/ProgressPlugin.js#L66

https://github.com/webpack/webpack/blob/001cab14692eb9a833c6b56709edbab547e291a1/examples/template-common.js#L36

https://github.com/webpack/webpack/blob/001cab14692eb9a833c6b56709edbab547e291a1/lib/util/semver.js#L204


**PoC Files and Comparisons:**

[PoC_1.zip](https://github.com/user-attachments/files/17352850/PoC_1.zip)
[PoC_2.zip](https://github.com/user-attachments/files/17352851/PoC_2.zip)
[PoC_3.zip](https://github.com/user-attachments/files/17352844/PoC_3.zip)
[PoC_4.zip](https://github.com/user-attachments/files/17352845/PoC_4.zip)
[PoC_5.zip](https://github.com/user-attachments/files/17352846/PoC_5.zip)
[PoC_6.zip](https://github.com/user-attachments/files/17352847/PoC_6.zip)
[PoC_7.zip](https://github.com/user-attachments/files/17352848/PoC_7.zip)
[PoC_8.zip](https://github.com/user-attachments/files/17352849/PoC_8.zip)




To evaluate the performance of this inefficient regular expression matching with varying input contents, the following commands can be executed within every PoC_i folder:

```bash
$ npm install # Install necessary dependencies for the minimal proof of concept environment.
$ time node poc.js # Run the script with maliciously constructed string and record the running time.
$ time node normal_string.js # Run the script with normal strings of same length and record the running time.
```

In the most severe case, on my machine, the maliciously crafted string took the following time, and caused CPU usage to reach 98% during program execution:

```
real    1m36.146s
user    1m36.103s
sys     0m0.020s
```

However, a normal string of the same length only took the following time:

```
real    0m0.230s
user    0m0.118s
sys     0m0.010s
```

This reveals a significant efficiency problem with the regular expression used in the program under certain conditions.

**Proposed Solution:**

A simple strategy could be to limit the length of the string being matched by the regular expression, thereby preventing excessive time consumption during regex matching. To completely avoid the issue, the pathological part of the regular expression that causes catastrophic backtracking should be modified.

**Background Information:**

Here are some real-world examples of issues caused by ReDoS vulnerabilities:

1. In 2019, Cloudflare experienced a service disruption lasting approximately 27 minutes due to a ReDoS vulnerability that allowed crafted input to overwhelm regex processing, resulting in significant performance degradation and temporary service outage (source: [Cloudflare Incident Report](https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/)).
2. Stack Overflow was affected by a ReDoS vulnerability in 2016, causing multiple instances of service degradation and temporary outages of up to 34 minutes during peak traffic periods due to inefficient regular expression patterns (source: [Stack Overflow Incident Report](http://stackstatus.net/post/147710624694/outage-postmortem-july-20-2016)).

Thank you for your attention to this matter. Your evaluation and response to this potential security concern would be greatly appreciated.

Best regards,
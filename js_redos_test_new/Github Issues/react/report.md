项目地址：https://github.com/facebook/react

Issues地址：https://github.com/facebook/react/issues/31174

> 下面是Issues原文↓

---

# Potential ReDoS Vulnerability or Inefficient Regular Expression in Project: Need for Assessment and Mitigation

Hello,

I am writing to report a potential Regular Expression Denial of Service (ReDoS) vulnerability or Inefficient Regular Expression in the project. When using specially crafted input strings in the context, it may lead to extremely high CPU usage, application freezing, or denial of service attacks.

**Location of Issue:**

The vulnerability is related to a regular expression used in the following validation file, which may result in significantly prolonged execution times under certain conditions.

https://github.com/facebook/react/blob/68dbd84b61cc2504c30e19f748f59a52d331f851/fixtures/dom/src/components/IssueList.js#L4

https://github.com/facebook/react/blob/68dbd84b61cc2504c30e19f748f59a52d331f851/scripts/rollup/modules.js#L50

https://github.com/facebook/react/blob/68dbd84b61cc2504c30e19f748f59a52d331f851/packages/react-devtools-shared/src/backend/utils.js#L388

https://github.com/facebook/react/blob/68dbd84b61cc2504c30e19f748f59a52d331f851/packages/internal-test-utils/consoleMock.js#L265

**PoC Files and Comparisons:**

[file]

To evaluate the performance of this inefficient regular expression matching with varying input contents, the following commands can be executed within the PoC folder:

```bash
$ npm install # Install necessary dependencies for the minimal proof of concept environment.
$ time node poc.js # Run the script with maliciously constructed string and record the running time.
$ time node normal_string.js # Run the script with normal strings of same length and record the running time.
```

In the most severe case, on my machine, the maliciously crafted string took the following time, and caused CPU usage to reach 98% during program execution:

```
real    1m31.225s
user    1m30.996s
sys     0m0.020s
```

However, a normal string of the same length only took the following time:

```
real    0m0.044s
user    0m0.013s
sys     0m0.013s
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
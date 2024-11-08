Hello,

I am writing to report a potential Regular Expression Denial of Service (ReDoS) vulnerability or Inefficient Regular Expression in the project. When using specially crafted input strings in the context, it may lead to extremely high CPU usage, application freezing, or denial of service attacks.

**Location of Issue:**

The vulnerability is related to a regular expression used in the following validation file, which may result in significantly prolonged execution times under certain conditions.

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/npm/node_modules/pacote/lib/util/add-git-sha.js#L11

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/tools/eslint/node_modules/cross-spawn/lib/util/escape.js#L26

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/tools/eslint/node_modules/comment-parser/es6/util.js#L8

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/npm/node_modules/@isaacs/cliui/build/lib/index.js#L81

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/npm/node_modules/node-gyp/lib/process-release.js#L73

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/tools/eslint/node_modules/comment-parser/es6/parser/tokenizers/tag.js#L8

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/tools/eslint/node_modules/eslint/lib/linter/config-comment-parser.js#L48

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/tools/eslint/node_modules/eslint/lib/linter/config-comment-parser.js#L96

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/tools/eslint/node_modules/eslint-plugin-jsdoc/src/jsdocUtils.js#L1307

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/npm/lib/utils/error-message.js#L165

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/npm/node_modules/npm-package-arg/lib/npa.js#L327

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/npm/node_modules/hosted-git-info/lib/hosts.js#L7

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/npm/node_modules/@npmcli/git/lib/lines-to-revs.js#L140

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/npm/node_modules/aggregate-error/index.js#L5

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/npm/node_modules/diff/dist/diff.js#L436

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/deps/v8/tools/profile.mjs#L178

https://github.com/nodejs/node/blob/559985cb7aec4e3cd387eb0f8442eea989cfedf3/lib/_tls_common.js#L134

**PoC Files and Comparisons:**

[PoC_1.zip](https://github.com/user-attachments/files/17349397/PoC_1.zip)
[PoC_2.zip](https://github.com/user-attachments/files/17349399/PoC_2.zip)
[PoC_3.zip](https://github.com/user-attachments/files/17349407/PoC_3.zip)
[PoC_4.zip](https://github.com/user-attachments/files/17349408/PoC_4.zip)
[PoC_5.zip](https://github.com/user-attachments/files/17349409/PoC_5.zip)
[PoC_6.zip](https://github.com/user-attachments/files/17349410/PoC_6.zip)
[PoC_7.zip](https://github.com/user-attachments/files/17349411/PoC_7.zip)
[PoC_8.zip](https://github.com/user-attachments/files/17349412/PoC_8.zip)
[PoC_9.zip](https://github.com/user-attachments/files/17349413/PoC_9.zip)
[PoC_10.zip](https://github.com/user-attachments/files/17349414/PoC_10.zip)
[PoC_11.zip](https://github.com/user-attachments/files/17349415/PoC_11.zip)
[PoC_12.zip](https://github.com/user-attachments/files/17349400/PoC_12.zip)
[PoC_13.zip](https://github.com/user-attachments/files/17349401/PoC_13.zip)
[PoC_14.zip](https://github.com/user-attachments/files/17349402/PoC_14.zip)
[PoC_15.zip](https://github.com/user-attachments/files/17349404/PoC_15.zip)
[PoC_16.zip](https://github.com/user-attachments/files/17349405/PoC_16.zip)
[PoC_17.zip](https://github.com/user-attachments/files/17349406/PoC_17.zip)

To evaluate the performance of this inefficient regular expression matching with varying input contents, the following commands can be executed within every PoC_i folder:

```bash
$ npm install # Install necessary dependencies for the minimal proof of concept environment.
$ time node poc.js # Run the script with maliciously constructed string and record the running time.
$ time node normal_string.js # Run the script with normal strings of same length and record the running time.
```

In the most severe case, on my machine, the maliciously crafted string took the following time, and caused CPU usage to reach 98% during program execution:

```
real    2m30.964s
user    2m30.785s
sys     0m0.060s
```

However, a normal string of the same length only took the following time:

```
real    0m0.118s
user    0m0.086s
sys     0m0.008s
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
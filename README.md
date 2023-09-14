# smartcontract-benchmark
These repositories contain datasets, including a small dataset, a labelled dataset with 389 test cases, and a scaled dataset.

Small Dataset Repository:
- Contains 110 contract test cases divided into 11 subdatasets.
- Includes 10 subdatasets with known vulnerabilities in the Top 10 categories.
- Provides one subdataset with correct test cases.

Labelled Dataset Repository:
- Hosts 389 test cases, with 372 identified as vulnerable and 17 labeled as safe.

Scaled Dataset Repository:
- Includes 20,000 unique Solidity contracts from October 25, 2016, to February 23, 2023.


## Top 10 categories:
1. Reentrancy
2. Arithmetic
3. Gasless send
4. unsafe suicidal
5. unsafe delegatecall
6. unchecked send
7. TOD
8. time manipulation
9. tx.origin
10. bad randomness


## Labelled dataset:

<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Type</th>
      <th>Description</th>
      <th>Number</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Reentrancy</td>
      <td>This vulnerability occurs when a contract calls an external contract, and the called contract then calls back into the calling contract before the first invocation is finished. </td>
      <td>81</td>   
    </tr>
    <tr>
      <th>1</th>
      <td>Arithmetic</td>
      <td>This occurs when an arithmetic opera- tion generates a value that exceeds the range that can be represented within the fixed number of bits designated for integers in the EVM. </td>
      <td>65</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Unchecked send</td>
      <td>This vulnerability happens when the call fails accidentally or an attacker forces the call to fail. It is also described as ``unhandled exceptions``, ``exception disorder``, or ``unchecked low-level call``.</td>
      <td>52</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Unsafe delegatecall</td>
      <td>This vulnerability rises from the DELEGATECALL instruction, which allows a contract to dynamically load code from another contract at runtime.</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Transaction Ordering Dependence</td>
      <td>This vulnerability, is also described as TOD, arises when a contract’s behaviour depends on the order of transactions.</td>
      <td>60</td>
    </tr>
      <tr>
      <th>5</th>
      <td>Time manipulation</td>
      <td>This vulnerability arises when smart contracts rely on the timestamp information from blocks.</td>
      <td>60</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Bad randomness</td>
      <td>This vulnerability pertains to the flawed generation of random numbers within smart contracts. Random numbers often influence the decisions or outcomes of contract functionalities. </td>
      <td>10</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Authorization through tx.origin</td>
      <td>This vulnerability arises when the tx.origin variable is exploited by attackers. </td>
      <td>11</td>
    </tr>
      <tr>
      <th>8</th>
      <td>Unsafe suicidal</td>
      <td>This vulnerability manifests when the SELFDESTRUCT function is improperly secured and subsequently exploited by attackers. </td>
      <td>60</td>
    </tr>
        <tr>
      <th>9</th>
      <td>Gasless send</td>
      <td>This vulnerability occurs when there’s an insufficient amount of gas to carry out an external call, resulting in the reversion of the transaction.</td>
      <td>60</td>
    </tr>
        <tr>
      <th>10</th>
      <td>Safe contracts</td>
      <td>This subdataset contains no vulnerable contracts</td>
      <td>17</td>
    </tr>
  </tbody>
</table>
</div>

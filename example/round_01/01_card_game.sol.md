# Card Game

The was the simplest problem in the competition with a 60% of success rate. For
a given an array a of n distinct integers, we need to print the sum of maximum
values among all possible subsets with k elements. The final number should be
computed modulo MOD=1000000007, which is a prime number. First we should sort
all numbers, such that a [1] < a [2] < ... < a [n].

Let's see in how many times the number a [i] appears as the maximum number in
some subsets, provided that i >= k. From all numbers less than a [i] we can
choose any k - 1, which is exactly equal to bin [i - 1][k - 1] where bin [n][k]
is a binomial coefficient (see http://en.wikipedia.org/wiki/Binomial_coefficient).

Therefore, the final solution is the sum of a [i] * bin [i - 1][k - 1], where i
goes from k to n, and we need to compute all binomial coefficients bin [k -
1][k - 1], ..., bin [n - 1][k - 1]. That can be done in many ways. The simplest
way is to precompute all binomial coefficient using simple recurrent formula

  bin [0][0] = 1;
  for (n = 1; n < MAXN; n++) {
    bin [n][0] = 1;
    bin [n][n] = 1;
    for (k = 1; k < n; k++) {
      bin [n][k] = bin [n - 1][k] + bin [n - 1][k - 1];
      if (bin [n][k] >= MOD) {
        bin [n][k] -= MOD;
      }
    }
  }

  qsort (a, n, sizeof(long), compare);
  sol = 0;
  for (int i = k - 1; i < n; i++) {
    sol += ((long long) (a [i] % MOD)) * bin [i][k - 1];
    sol = sol % MOD;
  }

Note that we are not using % operator in the calculation of the binomial
coefficient, as subtraction is much faster. The overall time complexity is O (n
log n) for sorting and O (n^2) for computing the binomial coefficients.

Another way is to use recurrent formula bin [n + 1][k] = ((n + 1) / (n + 1 -
k)) * bin [n][k] and use Big Integer arithmetics involving division. As this
might be too slow, these values can be precomputed modulo MOD and stored in a
temporary file as the table is independent of the actual input and thus needs
to be computed only once.Since MOD is a prime number and use calculate the
inverse of the number (n + 1 - k) using Extended Eucledian algorithm (see
http://en.wikipedia.org/wiki/Modular_multiplicative_inverse) and multiply with
the inverse instead of dividing. This yields on O(n log n) solution.

By direct definition bin [n][k] = n! / (n - k)! k!, one can iterate through all
prime numbers p less than or equal to n, and calculate the power of p in bin
[n][k] using the formula a (n, k) = [n / p] + [n / p^2] + [n / p^3] + ... for
the maximum power of p dividing the factorial n!.

The most common mistakes were because competitors did not test the edge cases
when k = 1 or k = n, and forgot to define bin [0][0] = 1. Another mistake was
not storing the result in a 64-bit integer when multiplying two numbers.


Security

To solve this problem, first we are going to divide it in two steps:

1. Find out if there is a valid solution. We have to find the relationship between the sections of k1 and k2. Function f replaces some random characters of the key by '?', and function g produces a random permutation of its m sections. The sections of k1 are present in k2, but maybe, in a different order. Also, there can be differences between sections thanks to function f. So, if we want to find a solution, we have to check if all the sections of k1 are in k2 and vice-versa. But, one section of k1 can have several candidates (there are no differences between the section of k1 and the section of k2, except for ? characters) in k2. For example,

m = 2
k1 = "aaab"
k2 = "a???"

The section "aa" may correspond to the section "a?" or "??".

This problem can be solved using Maximum Bipartite Matching (http://en.wikipedia.org/wiki/Matching_%28graph_theory%29#Maximum_matchings_in_bipartite_graphs)The vertices can be divided in two disjoints sets: U1 (sections of k1) and U2 (sections of U2), and the relationship between vertices is: is node j of U2 (section j of k2) a possible candidate for node i of U1 (section i of k1). If the maximum bipartite matching of the resulting graph is m (all the sections in k1 were successfully paired with exactly one section of k2 and vice-versa), then we found a solution. Now, we have to produce the lexicographically smallest solution.

2. There is at least one valid solution, find the lexicographic smallest. This was the most problematic step for most competitors. One simple way to solve this step is to iterate over each '?' (from left to right) of k1, and replace it by 'a', verify if a valid solution exists, if it does, go to the next '?'; otherwise, try with 'b' and so on.

The worst case of the algorithm is:|alpha| * |k1| * O(Maximum Bipartite Matching)

Where alpha = {a, b, c, d, e, f}, |alpha| = 6.

A lot of user solutions failed with the following case:
36
?feedbfcaabfeab?b???fddcfbfbdcaeeecf
?b?ceffedfba?bdfffadbcefa?edeebaddbf

The right answer was:
afeedbfcaabfeababddffddcfbfbdcaeeecf

For a nice solution, please see Dmytro's solution (third place):
https://fbcdn-dragon-a.akamaihd.net/cfs-ak-ash3/676632/98/332530593518613_-/tmp-/QMb6Q7

Also Petr's solution (54th place): https://fbcdn-dragon-a.akamaihd.net/cfs-ak-prn1/676656/539/407001922726253_-/tmp-/etIGUD


Dead Pixels

To solve this problem, we can create an data structure which supports two kinds of operations, updating (insert/remove) a dead pixel and querying the number of different continuous interval with length P. An customized interval tree (from 0 to W-1) supports both the 2 operations in O(logN) and O(1) respectively. Here is one of the approach to construct the interval tree.
struct node {
   int left, right; // left and right boundary of the interval   
   int leftmost_dead_pixel, rightmost_dead_pixel, count;
} nd[N];


int F(int left, int right) {
   // given the position of the left and the right dead pixel
   // count the different position of a continuous interval with length P
   return max(right - left - P, 0);
}

// O(logN)
void update(int k, int dead_pixel_x) {
   update(leftchild, dead_pixel_x);
   update(rightchild, dead_pixel_x);
   nd[k].count = leftchild.count + rightchild.count;
   nd[k].count += F(leftchild.rightmost_dead_pixel, rightchild.leftmost_dead_pixel);
   nd[k].count -= F(leftchild.rightmost_dead_pixel, leftchild.right);
   nd[k].count -= F(rightchild.leftmost_dead_pixel, rightchild.left);
}

// O(1)
void query() {
   return root.count;
}

After that, by sorting the dead pixels by their y coordinates, inserting/removing those dead pixel and adding up the query result from the interval tree properly should be fine to find the different possible positions for the image. The overall complexity is O(N log N) where N is the number of dead pixels.


Additional Resources:
For more information, see the excellent analysis of all the problems here: http://notes.tweakblogs.net/blog/8674/facebook-hacker-cup-2013-round-1-problem-analysis.html

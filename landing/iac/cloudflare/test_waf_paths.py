import re
import unittest
from pathlib import Path

from waf_paths import EXACT_PATHS, PATH_SUBSTRINGS, build_expression


class WafPathsTest(unittest.TestCase):
    def test_matches_documented_rule(self):
        readme = Path(__file__).resolve().parents[3] / "README.md"
        expression = readme.read_text().split("```\n(http.request.uri.path", 1)[1]
        expression = "(http.request.uri.path" + expression.split("\n```", 1)[0]

        sets = re.findall(r"http\.request\.uri\.path in \{([^}]*)\}", expression)
        exact = set(re.findall(r'"([^"]+)"', " ".join(sets)))
        substrings = set(re.findall(r'contains "([^"]+)"', expression))

        self.assertEqual(set(EXACT_PATHS), exact)
        self.assertEqual(set(PATH_SUBSTRINGS), substrings)

    def test_expression_and_limits(self):
        expression = build_expression()

        self.assertLessEqual(len(expression), 4096)
        self.assertEqual(len(EXACT_PATHS), len(set(EXACT_PATHS)))
        self.assertEqual(len(PATH_SUBSTRINGS), len(set(PATH_SUBSTRINGS)))
        self.assertIn('"/.svn/wc.db"', expression)
        self.assertIn('contains "/.env"', expression)


if __name__ == "__main__":
    unittest.main()

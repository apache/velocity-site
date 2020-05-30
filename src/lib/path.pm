package path;

# The @patterns array is used to map filepaths to page treatments.  Each
# element must be an arrayref with 3 elements of its own: a regex pattern for
# selecting filepaths, the name of the subroutine from view.pm which will be
# invoked to generate the page, and a hashref of named parameters which will
# be passed to the view subroutine.

# CB TODO - pre/post processing should be triggered by the {{tags}} present in the file

our @patterns = (
	[qr"^/(?:index|news|who-we-are)\.mdtext$", standard => { template => "single_narrative.html", postprocessing => 1 }],
	[qr"^/(?:engine/.*/changes)\.mdtext$", standard => { template => "single_narrative.html", postprocessing => 1, extralogo => '/engine/devel/images/velocity-logo.png' }],
    [qr"^/engine/.*\.mdtext", standard => { template => "single_narrative.html", extralogo => '/engine/devel/images/velocity-logo.png' }],
	[qr"^/(?:tools/.*/changes)\.mdtext$", standard => { template => "single_narrative.html", postprocessing => 1, extralogo => '/tools/devel/images/velocitytools.png' }],
	[qr"FeedTool\.mdtext$", standard => { template => "single_narrative.html", preprocessing => 1, extralogo => '/tools/devel/images/velocitytools.png' }],
    [qr"^/tools/.*\.mdtext", standard => { template => "single_narrative.html", extralogo => '/tools/devel/images/velocitytools.png' }],
    [qr"^/rss/news.rss", rss => {} ],
	[qr"\.mdtext$", standard => { template => "single_narrative.html" }],
);

# The %dependecies hash is used when building pages that reference or depend
# upon other pages -- e.g. a sitemap, which depends upon the pages that it
# links to.  The keys for %dependencies are filepaths, and the values are
# arrayrefs containing other filepaths.

our %dependencies = (
    "index.html" => [ "content/news.xml" ],
    "news.html" => [ "content/news.xml" ],
);

1;

=head1 LICENSE

           Licensed to the Apache Software Foundation (ASF) under one
           or more contributor license agreements.  See the NOTICE file
           distributed with this work for additional information
           regarding copyright ownership.  The ASF licenses this file
           to you under the Apache License, Version 2.0 (the
           "License"); you may not use this file except in compliance
           with the License.  You may obtain a copy of the License at

             http://www.apache.org/licenses/LICENSE-2.0

           Unless required by applicable law or agreed to in writing,
           software distributed under the License is distributed on an
           "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
           KIND, either express or implied.  See the License for the
           specific language governing permissions and limitations
           under the License.



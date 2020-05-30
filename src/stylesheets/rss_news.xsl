<?xml version="1.0"?>
<!--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:news="http://velocity.apache.org/NEWS/1.0.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    exclude-result-prefixes="news"
    version="1.0">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
  <xsl:template name="replace-nl">
    <xsl:param name="str"/>
    <xsl:if test="$str">
      <xsl:variable name="before" select="substring-before($str, '&#10;&#10;')"/>
      <xsl:variable name="after" select="substring-after($str, '&#10;&#10;')"/>
      <xsl:text>&lt;p&gt;</xsl:text>
      <xsl:choose>
        <xsl:when test="$before">
          <xsl:value-of select="normalize-space($before)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($str)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&lt;/p&gt;</xsl:text>
      <xsl:call-template name="replace-nl">
        <xsl:with-param name="str" select="$after"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template match="/news:news">
    <rss xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/" version="2.0">
      <channel>
        <title>Apache Velocity Site News</title>
        <link>http://velocity.apache.org</link>
        <description>Recent news from Apache Velocity Site</description>
        <xsl:apply-templates select="news:items/news:item"/>
      </channel>
    </rss>
  </xsl:template>
  <xsl:template match="//news:item">
    <item>
      <title><xsl:value-of select="news:headline/text()"/></title>
      <link><xsl:text>http://velocity.apache.org/news.html#</xsl:text><xsl:value-of select="@id"/></link>
      <description><xsl:call-template name="replace-nl"><xsl:with-param name="str" select="news:text"/></xsl:call-template></description>
      <xsl:apply-templates select="news:categories/news:category"/>
      <pubDate><xsl:text>{{format_date_short(</xsl:text><xsl:value-of select="news:date"/><xsl:text>)}} 08:00:00 GMT</xsl:text></pubDate>
      <guid><xsl:text>http://velocity.apache.org/news.html#</xsl:text><xsl:value-of select="@id"/></guid>
      <dc:date><xsl:value-of select="news:date/text()"/><xsl:text>T08:00:00Z</xsl:text></dc:date>
    </item>
  </xsl:template>
  <xsl:template match="//news:category">
    <category> <xsl:copy-of select="node()"/> </category>
  </xsl:template>
  <xsl:template match="text()"/>
</xsl:stylesheet>

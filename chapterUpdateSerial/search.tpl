#encoding UTF-8
<style>
    .search-form {
        margin-bottom: 20px;
    }

    .form-group, .search-form .btn-success {
        margin-bottom: 5px !important;
    }

    .result-table td {
        vertical-align: middle !important;
        text-align: center;
    }

    .result-table td textarea {
        vertical-align: middle;
    }

    .pointer {
        cursor: pointer;
    }

    span.warn-tip {
        color: red;
        font-size: 12px;
        background-color: rgba(255,255,255,0.6);
        padding: 5px;
        border-radius: 4px;
    }

    .table td.book-status {
        line-height: 1.75em;
    }

    span.name-value {
        display: inline-block;
        margin: auto 5px;
    }

    span.name-value > span.name {
    }

    span.name-value > span.value {
        display: inline-block;
    }

    span.name-value > span.value.number {
        width: 40px;
    }

    span.name-value > span.value.datetime {
    }

    span.name-value > span.value.small {
        font-size: 0.8em;
    }

    td.text-left {
        text-align: left;
    }
</style>
<div ms-controller="core_book_search">
    <div class="form-inline search-form">
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">作品ID</div>
                <input type="text" class="form-control" ms-duplex="book_id">
            </div>
        </div>

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">作品名关键字</div>
                <input type="text" class="form-control" ms-duplex="keyword">
            </div>
        </div>

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">总字数 &gt;</div>
                <input type="text" class="form-control" ms-duplex="word_count_min">

                <div class="input-group-addon">&lt;</div>
                <input type="text" class="form-control" ms-duplex="word_count_max">

                <div class="input-group-addon">字</div>
            </div>
        </div>

        <span class="warn-tip">*注：当作品ID存在时，其他条件自动失效。</span><br/>
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">签约状态</div>
                <select class="form-control" ms-duplex="signed">
                    <option value="-1">全部</option>
                    <option value="1">签约</option>
                    <option value="0">未签约</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">创建时间</div>
                <input type="text" class="form-control form-date" ms-duplex="create_time_start">

                <div class="input-group-addon">-</div>
                <input type="text" class="form-control form-date" ms-duplex="create_time_end">
            </div>
        </div>

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">更新时间</div>
                <input type="text" class="form-control form-date" ms-duplex="release_time_start">

                <div class="input-group-addon">-</div>
                <input type="text" class="form-control form-date" ms-duplex="release_time_end">
            </div>
        </div>
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">结果按照</div>
                <select class="form-control" ms-duplex="order_field">
                    <option ms-repeat="order_field_list" ms-value="el.id">{{el.name}}</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <div class="input-group">
                <select class="form-control" ms-duplex="order_type">
                    <option value="0">降序</option>
                    <option value="1">升序</option>
                </select>
                <div class="input-group-addon">排列</div>
            </div>
        </div>

        <button class="btn btn-success" ms-click="clickSearch">搜索</button>

    </div>

    <!--下面是搜索结果-->

    <div class="panel panel-default">
        <table class="table table-striped table-bordered table-hover result-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>作品名</th>
                    <th>作者</th>
                    <th>属性</th>
                    <th>标签</th>
                    <th>数据统计</th>
                    <th>时间</th>
                    <th>连更天数</th>
                    <th ms-if="is_root==1">操作</th>
                </tr>
            </thead>
            <tbody>
                <tr ms-repeat-book="books">
                    <td>{{book.id}}</td>
                    <td>
                        <!--?<a ms-href="/manage/core/book/read/{{book.id}}.html" target="_blank">《{{book.name}}》</a>-->
                    </td>
                    <td>
                        <a class="pull-left" href="javascript:">{{book.author_tag.nickname}}</a>
                        <span class="pull-right">ID: {{book.author_tag.id}}</span>
                    </td>
                    <td class="book-status">
                        <span class="label pointer"
                              ms-class-1="label-danger:book.starred"
                              ms-class-2="label-default:!book.starred"
                              ms-click="changeStar(book)">星</span>
                        <span class="label"
                              ms-class-1="label-warning:book.signed"
                              ms-class-2="label-default:!book.singed"
                              ms-click="changeSign(book)">签</span>
                        <span class="label"
                              ms-class-1="label-success:book.finished"
                              ms-class-2="label-default:!book.finished">完</span>
                        <br>
                        <span class="label label-default"
                              ms-if="book.top_level_info == null"
                              ms-click="setTop(book)">TOP</span>
                        <span class="label label-primary"
                              ms-if="book.top_level_info != null"
                              ms-click="removeTop(book)">{{book.top_level_info.tag_name}} {{book.top_level_info.level}}</span>
                    </td>
                    <td>
                        <textarea ms-duplex="book['tags_str']"></textarea>
                        <a href="javascript:;" class="btn btn-success" ms-click="clickSaveTags(book)">保存</a>
                    </td>
                    <td class="text-left">
                        <span class="name-value">
                            <span class="name">章</span>
                            <span class="value number small">{{book.published_chapter_count}}</span>
                        </span>
                        <span class="name-value">
                            <span class="name">字</span>
                            <span class="value number small">{{book.word_count}}</span>
                        </span>
                        <span class="name-value">
                            <span class="name">图</span>
                            <span class="value number small">{{book.image_count}}</span>
                        </span><br>
                        <span class="name-value">
                            <span class="name">阅</span>
                            <span class="value number small">{{book.read_count}}</span>
                        </span>
                        <span class="name-value">
                            <span class="name">评</span>
                            <span class="value number small">{{book.comment_count}}</span>
                        </span><br>
                        <span class="name-value">
                            <span class="name">瓜</span>
                            <span class="value number small">{{book.pumpkin_info.count}}</span>
                        </span>
                        <span class="name-value">
                            <span class="name">藏</span>
                            <span class="value number small">{{book.favorer_count}}</span>
                        </span>
                        <span class="name-value">
                            <span class="name">享</span>
                            <span class="value number small">
                                <a href="javascript:;" ms-click="showBookShareRecord(book)">{{book.share_count}}</a>
                            </span>
                        </span>
                        <span class="name-value">
                            <span class="name">赏</span>
                            <span class="value number small">
                                <a href="javascript:;" ms-click="showBookRewardedRecord(book)">{{book.rewarded_coins}}</a>
                            </span>
                        </span>
                    </td>
                    <td class="text-left">
                        <span class="name-value">
                            <span class="name">建</span>
                            <span class="value datetime small">{{book.create_time_value | timestamp2date}}</span>
                        </span><br>
                        <span class="name-value">
                            <span class="name">更</span>
                            <span class="value datetime small">{{book.release_time_value | timestamp2date}}</span>
                        </span>
                    </td>

                    <td>
                            <a>{{updateday}} 天</a>
                    </td>

                    <td ms-if="is_root==1" class="sign_option">
                        <button class="btn btn-small btn-danger"
                                ms-click="deleteBook(book)">强制删除</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div ms-include-src="'/manage/widgets/pager.html'"></div>
</div>

<!--?<script>-->
    <!--?require(['tym'], function (TYM) {-->
        <!--?TYM.setPageParams(${json_params, no_escape=True});-->
    <!--?});-->
<!--?</script>-->
